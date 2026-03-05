package main

import (
	"fmt"
	"net/http"
	"private_planner_backend/internal/auth"
	"private_planner_backend/internal/database"
	"private_planner_backend/internal/models"
	"private_planner_backend/internal/update"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

const Version = "v0.1.1"

func main() {
	// Auto-update check
	if err := update.CheckAndApplyUpdate(Version); err != nil {
		fmt.Printf("Update check failed: %v\n", err)
	}

	database.InitDB("./planner.db")

	r := gin.Default()

	// Auth routes
	// Registration disabled for public as requested. Admin must create users.
	// Placeholder admin route for creating users and generating QR codes.
	r.POST("/admin/create-user", func(c *gin.Context) {
		// In a real app, this would be protected by admin middleware
		var req struct {
			Username string `json:"username" binding:"required"`
			Password string `json:"password" binding:"required"`
		}
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if err := auth.Register(req.Username, req.Password); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not register user"})
			return
		}

		var userID int
		err := database.DB.QueryRow("SELECT id FROM users WHERE username = ?", req.Username).Scan(&userID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		token, err := auth.GenerateQRToken(userID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not generate QR token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"message": "User created",
			"qr_data": gin.H{
				"url":   "http://localhost:8080", // Hardcoded for now
				"token": token,
			},
		})
	})

	r.POST("/qr-login", func(c *gin.Context) {
		var req struct {
			Token string `json:"token" binding:"required"`
		}
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		token, err := auth.LoginWithQR(req.Token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"token": token})
	})

	r.POST("/login", func(c *gin.Context) {
		var req struct {
			Username string `json:"username" binding:"required"`
			Password string `json:"password" binding:"required"`
		}
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		token, err := auth.Login(req.Username, req.Password)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"token": token})
	})

	// Serve profile pictures (could be protected, but static is easier for avatars usually)
	r.Static("/profile_pictures", "./profile_pictures")

	// Protected routes
	protected := r.Group("/api")
	protected.Use(authMiddleware())
	{
		protected.GET("/health", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"status": "ok", "user_id": c.MustGet("user_id")})
		})

		// Profile Picture Upload
		protected.POST("/profile/picture", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			file, err := c.FormFile("file")
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}

			filePath := fmt.Sprintf("profile_pictures/%d_%s", userID, file.Filename)
			if err := c.SaveUploadedFile(file, filePath); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not save file"})
				return
			}

			// Update user in DB
			_, err = database.DB.Exec("UPDATE users SET profile_picture_path = ? WHERE id = ?", filePath, userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			c.JSON(http.StatusOK, gin.H{"message": "Profile picture updated", "path": filePath})
		})

		// Household routes
		protected.POST("/household/create", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			
			// Ensure user has a household or create one
			var householdID *int
			err := database.DB.QueryRow("SELECT household_id FROM users WHERE id = ?", userID).Scan(&householdID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			if householdID == nil {
				// Create household
				res, err := database.DB.Exec("INSERT INTO households DEFAULT VALUES")
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create household"})
					return
				}
				hid, _ := res.LastInsertId()
				
				// Update user
				_, err = database.DB.Exec("UPDATE users SET household_id = ? WHERE id = ?", hid, userID)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update user"})
					return
				}
			}

			token, err := auth.GenerateHouseholdQRToken(userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not generate QR token"})
				return
			}

			c.JSON(http.StatusOK, gin.H{"token": token})
		})

		protected.POST("/household/join", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			var req struct {
				Token string `json:"token" binding:"required"`
			}
			if err := c.ShouldBindJSON(&req); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}

			// Verify token and get the creator's user_id
			var creatorID int
			var used bool
			err := database.DB.QueryRow("SELECT user_id, used FROM qr_tokens WHERE token = ? AND type = 'household_join'", req.Token).Scan(&creatorID, &used)
			if err != nil {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
				return
			}

			if used {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "token already used"})
				return
			}

			// Get creator's household_id
			var householdID *int
			err = database.DB.QueryRow("SELECT household_id FROM users WHERE id = ?", creatorID).Scan(&householdID)
			if err != nil || householdID == nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "creator not in a household"})
				return
			}

			// Update the joining user's household_id
			_, err = database.DB.Exec("UPDATE users SET household_id = ? WHERE id = ?", *householdID, userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not join household"})
				return
			}

			// Mark token as used
			database.DB.Exec("UPDATE qr_tokens SET used = TRUE WHERE token = ?", req.Token)

			c.JSON(http.StatusOK, gin.H{"message": "Joined household successfully"})
		})

		protected.GET("/household/members", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)

			var householdID *int
			err := database.DB.QueryRow("SELECT household_id FROM users WHERE id = ?", userID).Scan(&householdID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			if householdID == nil {
				// No household, return just the user
				var u models.User
				err = database.DB.QueryRow("SELECT id, username, profile_picture_path FROM users WHERE id = ?", userID).Scan(&u.ID, &u.Username, &u.ProfilePicturePath)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
				c.JSON(http.StatusOK, []models.User{u})
				return
			}

			rows, err := database.DB.Query("SELECT id, username, profile_picture_path FROM users WHERE household_id = ?", *householdID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			defer rows.Close()

			var members []models.User
			for rows.Next() {
				var u models.User
				err := rows.Scan(&u.ID, &u.Username, &u.ProfilePicturePath)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
				members = append(members, u)
			}
			c.JSON(http.StatusOK, members)
		})

		// Sync: Get all todos for user
		protected.GET("/todos", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			query := `
				SELECT t.id, t.user_id, t.owner_id, t.category_id, t.title, t.priority, t.status, t.time_estimate, t.due_date, t.encrypted_blob, t.version, t.deleted, t.updated_at 
				FROM todos t
				LEFT JOIN categories c ON t.category_id = c.id
				LEFT JOIN users u ON c.user_id = u.id
				LEFT JOIN users me ON me.id = ?
				WHERE t.user_id = ? 
				   OR t.owner_id = ? 
				   OR (c.shared_with_household = TRUE AND u.household_id = me.household_id AND me.household_id IS NOT NULL)
			`
			rows, err := database.DB.Query(query, userID, userID, userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			defer rows.Close()

			var todos []models.Todo
			for rows.Next() {
				var t models.Todo
				err := rows.Scan(&t.ID, &t.UserID, &t.OwnerID, &t.CategoryID, &t.Title, &t.Priority, &t.Status, &t.TimeEstimate, &t.DueDate, &t.EncryptedBlob, &t.Version, &t.Deleted, &t.UpdatedAt)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
				todos = append(todos, t)
			}
			c.JSON(http.StatusOK, todos)
		})

		// Sync: Push todos
		protected.POST("/todos/sync", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			var incomingTodos []models.Todo
			if err := c.ShouldBindJSON(&incomingTodos); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}

			tx, err := database.DB.Begin()
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			for _, t := range incomingTodos {
				_, err := tx.Exec(`
					INSERT INTO todos (id, user_id, owner_id, category_id, title, priority, status, time_estimate, due_date, encrypted_blob, version, deleted, updated_at)
					VALUES (?, COALESCE((SELECT user_id FROM todos WHERE id = ?), ?), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
					ON CONFLICT(id) DO UPDATE SET
						owner_id = excluded.owner_id,
						category_id = excluded.category_id,
						title = excluded.title,
						priority = excluded.priority,
						status = excluded.status,
						time_estimate = excluded.time_estimate,
						due_date = excluded.due_date,
						encrypted_blob = excluded.encrypted_blob,
						version = excluded.version,
						deleted = excluded.deleted,
						updated_at = CURRENT_TIMESTAMP
					WHERE excluded.version > todos.version`,
					t.ID, t.ID, userID, t.OwnerID, t.CategoryID, t.Title, t.Priority, t.Status, t.TimeEstimate, t.DueDate, t.EncryptedBlob, t.Version, t.Deleted, time.Now())
				if err != nil {
					tx.Rollback()
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
			}

			if err := tx.Commit(); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			c.JSON(http.StatusOK, gin.H{"message": "Sync successful"})
		})

		// Sync: Push todos
		protected.POST("/todos/sync", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			var incomingTodos []models.Todo
			if err := c.ShouldBindJSON(&incomingTodos); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}

			tx, err := database.DB.Begin()
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			for _, t := range incomingTodos {
				_, err := tx.Exec(`
					INSERT INTO todos (id, user_id, owner_id, category_id, title, priority, status, time_estimate, due_date, encrypted_blob, version, deleted, updated_at)
					VALUES (?, COALESCE((SELECT user_id FROM todos WHERE id = ?), ?), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
					ON CONFLICT(id) DO UPDATE SET
						owner_id = excluded.owner_id,
						category_id = excluded.category_id,
						title = excluded.title,
						priority = excluded.priority,
						status = excluded.status,
						time_estimate = excluded.time_estimate,
						due_date = excluded.due_date,
						encrypted_blob = excluded.encrypted_blob,
						version = excluded.version,
						deleted = excluded.deleted,
						updated_at = CURRENT_TIMESTAMP
					WHERE excluded.version > todos.version`,
					t.ID, t.ID, userID, t.OwnerID, t.CategoryID, t.Title, t.Priority, t.Status, t.TimeEstimate, t.DueDate, t.EncryptedBlob, t.Version, t.Deleted, time.Now())
				if err != nil {
					tx.Rollback()
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
			}

			if err := tx.Commit(); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			c.JSON(http.StatusOK, gin.H{"message": "Sync successful"})
		})

		// Comments Sync
		protected.GET("/comments", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			rows, err := database.DB.Query("SELECT id, todo_id, user_id, encrypted_blob, created_at FROM comments WHERE todo_id IN (SELECT id FROM todos WHERE user_id = ? OR owner_id = ?)", userID, userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			defer rows.Close()

			var comments []models.Comment
			for rows.Next() {
				var cm models.Comment
				err := rows.Scan(&cm.ID, &cm.TodoID, &cm.UserID, &cm.EncryptedBlob, &cm.CreatedAt)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
				comments = append(comments, cm)
			}
			c.JSON(http.StatusOK, comments)
		})

		protected.POST("/comments", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			var cm models.Comment
			if err := c.ShouldBindJSON(&cm); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			_, err := database.DB.Exec("INSERT INTO comments (id, todo_id, user_id, encrypted_blob) VALUES (?, ?, ?, ?)", cm.ID, cm.TodoID, userID, cm.EncryptedBlob)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			c.JSON(http.StatusOK, gin.H{"message": "Comment added"})
		})

		// File Upload
		protected.POST("/todos/:id/upload", func(c *gin.Context) {
			todoID := c.Param("id")
			userID := c.MustGet("user_id").(int)
			file, err := c.FormFile("file")
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}

			encryptedName := c.PostForm("encrypted_name")
			attachmentID := c.PostForm("attachment_id")

			filePath := "uploads/" + attachmentID + "_" + file.Filename
			if err := c.SaveUploadedFile(file, filePath); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			_, err = database.DB.Exec("INSERT INTO attachments (id, todo_id, user_id, file_path, encrypted_name) VALUES (?, ?, ?, ?, ?)", attachmentID, todoID, userID, filePath, encryptedName)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}

			c.JSON(http.StatusOK, gin.H{"message": "File uploaded successfully"})
		})

		protected.GET("/attachments/:id", func(c *gin.Context) {
			attachmentID := c.Param("id")
			var filePath string
			err := database.DB.QueryRow("SELECT file_path FROM attachments WHERE id = ?", attachmentID).Scan(&filePath)
			if err != nil {
				c.JSON(http.StatusNotFound, gin.H{"error": "Attachment not found"})
				return
			}
			c.File(filePath)
		})

		// Categories Sync
		protected.GET("/categories", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			query := `
				SELECT c.id, c.user_id, c.encrypted_name, c.shared_with_household, c.created_at 
				FROM categories c
				LEFT JOIN users u ON c.user_id = u.id
				LEFT JOIN users me ON me.id = ?
				WHERE c.user_id = ? 
				   OR c.id IN (SELECT category_id FROM category_shares WHERE shared_with_user_id = ?)
				   OR (c.shared_with_household = TRUE AND u.household_id = me.household_id AND me.household_id IS NOT NULL)
			`
			rows, err := database.DB.Query(query, userID, userID, userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			defer rows.Close()

			var categories []models.Category
			for rows.Next() {
				var cat models.Category
				err := rows.Scan(&cat.ID, &cat.UserID, &cat.EncryptedName, &cat.SharedWithHousehold, &cat.CreatedAt)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
				categories = append(categories, cat)
			}
			c.JSON(http.StatusOK, categories)
		})

		protected.POST("/categories", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			var cat models.Category
			if err := c.ShouldBindJSON(&cat); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			query := `
				INSERT INTO categories (id, user_id, encrypted_name, shared_with_household) 
				VALUES (?, COALESCE((SELECT user_id FROM categories WHERE id = ?), ?), ?, ?) 
				ON CONFLICT(id) DO UPDATE SET 
					encrypted_name = excluded.encrypted_name,
					shared_with_household = excluded.shared_with_household
			`
			_, err := database.DB.Exec(query, cat.ID, cat.ID, userID, cat.EncryptedName, cat.SharedWithHousehold)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			c.JSON(http.StatusOK, gin.H{"message": "Category saved"})
		})

		// Sharing Sync
		protected.GET("/shares", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			rows, err := database.DB.Query("SELECT id, category_id, user_id, shared_with_user_id, permission FROM category_shares WHERE user_id = ?", userID)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			defer rows.Close()

			var shares []models.CategoryShare
			for rows.Next() {
				var s models.CategoryShare
				err := rows.Scan(&s.ID, &s.CategoryID, &s.UserID, &s.SharedWithUserID, &s.Permission)
				if err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
					return
				}
				shares = append(shares, s)
			}
			c.JSON(http.StatusOK, shares)
		})

		protected.POST("/shares", func(c *gin.Context) {
			userID := c.MustGet("user_id").(int)
			var s models.CategoryShare
			if err := c.ShouldBindJSON(&s); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
				return
			}
			_, err := database.DB.Exec("INSERT INTO category_shares (id, category_id, user_id, shared_with_user_id, permission) VALUES (?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET permission = excluded.permission", s.ID, s.CategoryID, userID, s.SharedWithUserID, s.Permission)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			c.JSON(http.StatusOK, gin.H{"message": "Share saved"})
		})
	}

	r.Run(":8080")
}

func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header required"})
			c.Abort()
			return
		}

		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid authorization header format"})
			c.Abort()
			return
		}

		claims, err := auth.VerifyToken(parts[1])
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		c.Set("user_id", claims.UserID)
		c.Next()
	}
}

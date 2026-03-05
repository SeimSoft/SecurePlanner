package auth

import (
	"errors"
	"private_planner_backend/internal/database"
	"private_planner_backend/internal/models"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

var jwtKey = []byte("your_secret_key") // In production, use an environment variable

type Claims struct {
	UserID int `json:"user_id"`
	jwt.RegisteredClaims
}

func Register(username, password string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	_, err = database.DB.Exec("INSERT INTO users (username, password_hash) VALUES (?, ?)", username, string(hashedPassword))
	return err
}

func Login(username, password string) (string, error) {
	var user models.User
	err := database.DB.QueryRow("SELECT id, password_hash FROM users WHERE username = ?", username).Scan(&user.ID, &user.PasswordHash)
	if err != nil {
		return "", errors.New("invalid username or password")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password))
	if err != nil {
		return "", errors.New("invalid username or password")
	}

	expirationTime := time.Now().Add(72 * time.Hour)
	claims := &Claims{
		UserID: user.ID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtKey)
}

func VerifyToken(tokenString string) (*Claims, error) {
	claims := &Claims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})

	if err != nil || !token.Valid {
		return nil, errors.New("invalid token")
	}

	return claims, nil
}

func GenerateQRToken(userID int) (string, error) {
	// Generate a secure random token
	token := time.Now().String() // Placeholder, use better random in production
	_, err := database.DB.Exec("INSERT INTO qr_tokens (token, user_id, type) VALUES (?, ?, 'login')", token, userID)
	return token, err
}

func GenerateHouseholdQRToken(userID int) (string, error) {
	token := time.Now().String() + "_household" // Placeholder
	_, err := database.DB.Exec("INSERT INTO qr_tokens (token, user_id, type) VALUES (?, ?, 'household_join')", token, userID)
	return token, err
}

func LoginWithQR(token string) (string, error) {
	var userID int
	var used bool
	err := database.DB.QueryRow("SELECT user_id, used FROM qr_tokens WHERE token = ?", token).Scan(&userID, &used)
	if err != nil {
		return "", errors.New("invalid or expired token")
	}

	if used {
		return "", errors.New("token already used")
	}

	// Mark token as used
	_, err = database.DB.Exec("UPDATE qr_tokens SET used = TRUE WHERE token = ?", token)
	if err != nil {
		return "", err
	}

	// Generate JWT
	expirationTime := time.Now().Add(72 * time.Hour)
	claims := &Claims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	jwtToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return jwtToken.SignedString(jwtKey)
}

func ListUsers() ([]models.User, error) {
	rows, err := database.DB.Query("SELECT id, username, profile_picture_path, household_id, created_at FROM users")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []models.User
	for rows.Next() {
		var u models.User
		err := rows.Scan(&u.ID, &u.Username, &u.ProfilePicturePath, &u.HouseholdID, &u.CreatedAt)
		if err != nil {
			return nil, err
		}
		users = append(users, u)
	}
	return users, nil
}

func DeleteUser(username string) error {
	_, err := database.DB.Exec("DELETE FROM users WHERE username = ?", username)
	return err
}

func ResetPassword(username, newPassword string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	res, err := database.DB.Exec("UPDATE users SET password_hash = ? WHERE username = ?", string(hashedPassword), username)
	if err != nil {
		return err
	}
	rows, err := res.RowsAffected()
	if err != nil {
		return err
	}
	if rows == 0 {
		return errors.New("user not found")
	}
	return nil
}

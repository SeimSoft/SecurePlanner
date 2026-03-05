package models

import "time"

type User struct {
	ID           int       `json:"id"`
	Username     string    `json:"username"`
	PasswordHash string    `json:"-"`
	CreatedAt    time.Time `json:"created_at"`
}

type Todo struct {
	ID            string    `json:"id"`
	UserID        int       `json:"user_id"`
	OwnerID       *int      `json:"owner_id"`
	CategoryID    *string   `json:"category_id"`
	Title         string    `json:"title"`
	Priority      int       `json:"priority"`
	Status        string    `json:"status"`
	TimeEstimate  string    `json:"time_estimate"`
	DueDate       time.Time `json:"due_date"`
	EncryptedBlob string    `json:"encrypted_blob"`
	Version       int       `json:"version"`
	Deleted       bool      `json:"deleted"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type Category struct {
	ID            string    `json:"id"`
	UserID        int       `json:"user_id"`
	EncryptedName string    `json:"encrypted_name"`
	CreatedAt     time.Time `json:"created_at"`
}

type CategoryShare struct {
	ID               string `json:"id"`
	CategoryID       string `json:"category_id"`
	UserID           int    `json:"user_id"`
	SharedWithUserID int    `json:"shared_with_user_id"`
	Permission       string `json:"permission"`
}

type Comment struct {
	ID            string    `json:"id"`
	TodoID        string    `json:"todo_id"`
	UserID        int       `json:"user_id"`
	EncryptedBlob string    `json:"encrypted_blob"`
	CreatedAt     time.Time `json:"created_at"`
}

type Attachment struct {
	ID            string    `json:"id"`
	TodoID        string    `json:"todo_id"`
	UserID        int       `json:"user_id"`
	FilePath      string    `json:"file_path"`
	EncryptedName string    `json:"encrypted_name"`
	CreatedAt     time.Time `json:"created_at"`
}

package database

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

var DB *sql.DB

func InitDB(dataSourceName string) {
	var err error
	DB, err = sql.Open("sqlite3", dataSourceName)
	if err != nil {
		log.Fatal(err)
	}

	createTables := `
	CREATE TABLE IF NOT EXISTS users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		username TEXT UNIQUE NOT NULL,
		password_hash TEXT NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	);

	CREATE TABLE IF NOT EXISTS categories (
		id TEXT PRIMARY KEY,
		user_id INTEGER NOT NULL,
		encrypted_name TEXT NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY(user_id) REFERENCES users(id)
	);

	CREATE TABLE IF NOT EXISTS category_shares (
		id TEXT PRIMARY KEY,
		category_id TEXT NOT NULL,
		user_id INTEGER NOT NULL,
		shared_with_user_id INTEGER NOT NULL,
		permission TEXT DEFAULT 'read', -- 'read', 'write'
		FOREIGN KEY(category_id) REFERENCES categories(id),
		FOREIGN KEY(user_id) REFERENCES users(id),
		FOREIGN KEY(shared_with_user_id) REFERENCES users(id)
	);

	CREATE TABLE IF NOT EXISTS todos (
		id TEXT PRIMARY KEY,
		user_id INTEGER NOT NULL,
		owner_id INTEGER,
		category_id TEXT,
		title TEXT,
		priority INTEGER,
		status TEXT DEFAULT 'Backlog',
		time_estimate TEXT,
		due_date DATETIME,
		encrypted_blob TEXT NOT NULL,
		version INTEGER DEFAULT 1,
		deleted BOOLEAN DEFAULT FALSE,
		updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY(user_id) REFERENCES users(id),
		FOREIGN KEY(owner_id) REFERENCES users(id),
		FOREIGN KEY(category_id) REFERENCES categories(id)
	);

	CREATE TABLE IF NOT EXISTS comments (
		id TEXT PRIMARY KEY,
		todo_id TEXT NOT NULL,
		user_id INTEGER NOT NULL,
		encrypted_blob TEXT NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY(todo_id) REFERENCES todos(id),
		FOREIGN KEY(user_id) REFERENCES users(id)
	);

	CREATE TABLE IF NOT EXISTS attachments (
		id TEXT PRIMARY KEY,
		todo_id TEXT NOT NULL,
		user_id INTEGER NOT NULL,
		file_path TEXT NOT NULL,
		encrypted_name TEXT NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY(todo_id) REFERENCES todos(id),
		FOREIGN KEY(user_id) REFERENCES users(id)
	);
	`

	_, err = DB.Exec(createTables)
	if err != nil {
		log.Fatal(err)
	}
}

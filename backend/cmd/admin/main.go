package main

import (
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"private_planner_backend/internal/auth"
	"private_planner_backend/internal/database"

	"github.com/skip2/go-qrcode"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		return
	}

	command := os.Args[1]

	switch command {
	case "create":
		createCmd := flag.NewFlagSet("create", flag.ExitOnError)
		username := createCmd.String("username", "", "Username")
		password := createCmd.String("password", "", "Password")
		dbPath := createCmd.String("db", "./planner.db", "Path to the database file")
		createCmd.Parse(os.Args[2:])

		if *username == "" || *password == "" {
			fmt.Println("Usage: admin create -username <username> -password <password> [-db <path>]")
			return
		}

		database.InitDB(*dbPath)
		if err := auth.Register(*username, *password); err != nil {
			log.Fatalf("Could not register user: %v", err)
		}

		var userID int
		err := database.DB.QueryRow("SELECT id FROM users WHERE username = ?", *username).Scan(&userID)
		if err != nil {
			log.Fatalf("Could not find created user: %v", err)
		}

		token, err := auth.GenerateQRToken(userID)
		if err != nil {
			log.Fatalf("Could not generate QR token: %v", err)
		}

		qrData := map[string]interface{}{
			"url":   "http://localhost:8080", // Hardcoded for now
			"token": token,
		}

		jsonData, _ := json.Marshal(qrData)
		pairingCode := base64.StdEncoding.EncodeToString(jsonData)

		fmt.Printf("\n--- USER CREATED SUCCESSFULLY ---\n")
		fmt.Printf("Username: %s\n", *username)
		fmt.Printf("Pairing Code: %s\n", pairingCode)
		fmt.Printf("\n--- QR CODE ---\n")

		q, err := qrcode.New(string(jsonData), qrcode.Medium)
		if err != nil {
			log.Printf("Could not generate QR code: %v", err)
		} else {
			fmt.Print(q.ToSmallString(false))
		}
		fmt.Printf("----------------------------------\n\n")

	case "list":
		listCmd := flag.NewFlagSet("list", flag.ExitOnError)
		dbPath := listCmd.String("db", "./planner.db", "Path to the database file")
		listCmd.Parse(os.Args[2:])

		database.InitDB(*dbPath)
		users, err := auth.ListUsers()
		if err != nil {
			log.Fatalf("Could not list users: %v", err)
		}
		fmt.Printf("\n--- USERS ---\n")
		for _, u := range users {
			householdStr := "none"
			if u.HouseholdID != nil {
				householdStr = fmt.Sprintf("%d", *u.HouseholdID)
			}
			fmt.Printf("ID: %d | Username: %s | Household: %s | Created: %s\n", 
				u.ID, u.Username, householdStr, u.CreatedAt.Format("2006-01-02 15:04:05"))
		}
		fmt.Printf("-------------\n\n")

	case "delete":
		deleteCmd := flag.NewFlagSet("delete", flag.ExitOnError)
		username := deleteCmd.String("username", "", "Username to delete")
		dbPath := deleteCmd.String("db", "./planner.db", "Path to the database file")
		deleteCmd.Parse(os.Args[2:])

		if *username == "" {
			fmt.Println("Usage: admin delete -username <username> [-db <path>]")
			return
		}

		database.InitDB(*dbPath)
		if err := auth.DeleteUser(*username); err != nil {
			log.Fatalf("Could not delete user: %v", err)
		}
		fmt.Printf("User '%s' deleted successfully.\n", *username)

	case "reset-password":
		resetCmd := flag.NewFlagSet("reset-password", flag.ExitOnError)
		username := resetCmd.String("username", "", "Username")
		password := resetCmd.String("password", "", "New Password")
		dbPath := resetCmd.String("db", "./planner.db", "Path to the database file")
		resetCmd.Parse(os.Args[2:])

		if *username == "" || *password == "" {
			fmt.Println("Usage: admin reset-password -username <username> -password <password> [-db <path>]")
			return
		}

		database.InitDB(*dbPath)
		if err := auth.ResetPassword(*username, *password); err != nil {
			log.Fatalf("Could not reset password: %v", err)
		}
		fmt.Printf("Password for user '%s' reset successfully.\n", *username)

	default:
		printUsage()
	}
}

func printUsage() {
	fmt.Println("Usage: admin <command> [arguments]")
	fmt.Println("Commands:")
	fmt.Println("  create         Create a new user and generate pairing code/QR")
	fmt.Println("  list           List all registered users")
	fmt.Println("  delete         Delete a user")
	fmt.Println("  reset-password Reset a user's password")
}

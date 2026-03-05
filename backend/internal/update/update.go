package update

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"runtime"

	"github.com/minio/selfupdate"
)

const repo = "SeimSoft/SecurePlanner"

type Release struct {
	TagName string  `json:"tag_name"`
	Assets  []Asset `json:"assets"`
}

type Asset struct {
	Name               string `json:"name"`
	BrowserDownloadURL string `json:"browser_download_url"`
}

func CheckAndApplyUpdate(currentVersion string) error {
	if os.Getenv("AUTO_UPDATE_ENABLED") != "true" {
		return nil
	}

	fmt.Printf("Checking for updates (current version: %s)...\n", currentVersion)

	resp, err := http.Get(fmt.Sprintf("https://api.github.com/repos/%s/releases/latest", repo))
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	var release Release
	if err := json.NewDecoder(resp.Body).Decode(&release); err != nil {
		return err
	}

	if release.TagName == currentVersion {
		fmt.Println("Already on the latest version.")
		return nil
	}

	fmt.Printf("New version found: %s. Downloading...\n", release.TagName)

	// Find the correct asset for this OS/Arch
	assetName := fmt.Sprintf("backend-%s-%s", runtime.GOOS, runtime.GOARCH)
	if runtime.GOOS == "windows" {
		assetName += ".exe"
	}

	var downloadURL string
	for _, asset := range release.Assets {
		if asset.Name == assetName {
			downloadURL = asset.BrowserDownloadURL
			break
		}
	}

	if downloadURL == "" {
		return fmt.Errorf("no suitable asset found for %s/%s", runtime.GOOS, runtime.GOARCH)
	}

	resp, err = http.Get(downloadURL)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if err := selfupdate.Apply(resp.Body, selfupdate.Options{}); err != nil {
		return err
	}

	fmt.Printf("Updated to %s successfully. Please restart the server.\n", release.TagName)
	os.Exit(0) // Exit so process manager can restart it
	return nil
}

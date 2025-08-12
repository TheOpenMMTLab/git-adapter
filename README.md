
# get-artifact-from-git

This project provides simple shell scripts to fetch files from and push files to a remote Git repository. It is designed for automation and CI/CD pipelines, supporting Overleaf and other Git-based services.

## Features

- **get.sh**: Download a file from a remote Git repository.
- **put.sh**: Upload (commit and push) a file to a remote Git repository.

---

## Usage

### Prerequisites

- Bash shell
- git installed
- (Optional) Set your Git token for authentication:
  ```bash
  export GIT_TOKEN=yourGitToken123
  ```

### Download a file from a Git repository

```bash
./get.sh \
  --repo <repo-url> \
  --input-path <remote-file-path> \
  --output-path <local-file-path>
```


### Upload a file to a Git repository

```bash
./put.sh \
  --repo <repo-url> \
  --input-path <local-file-path> \
  --output-path <remote-file-path> \
  --commit-message "Your commit message"
```

---

## Build Docker Image

```bash
docker build -t frittenburger/mmut-git-adapter:dev .
```

---

## License

MIT License
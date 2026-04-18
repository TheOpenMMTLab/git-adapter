
# git-adapter

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
  --output-path <local-file-path> \
  [--ref <commit|tag|branch>]
```

`--ref` is optional. If set, the script checks out that commit, tag, or branch before copying the file.


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
docker build -t frittenburger/git-adapter:dev .
```

## Test With Docker Run

```bash
docker run --rm \
  -e GIT_TOKEN="$GIT_TOKEN" \
  -v "$PWD:/work" \
  frittenburger/git-adapter:dev \
  bash /app/get.sh \
    --repo <repo-url> \
    --input-path <remote-file-path> \
    --output-path /work/<local-file-path> \
    --ref <commit|tag|branch>
```

`--ref` is optional and can be omitted.

---

## License

MIT License
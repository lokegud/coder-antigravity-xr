terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.12"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Variables
variable "dotfiles_uri" {
  description = "Dotfiles repo URI (optional)"
  default     = ""
  type        = string
}

# Admin parameters
data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU cores (4 minimum for light editing, 8+ for XR development)"
  default      = "8"
  type         = "number"
  mutable      = true

  option {
    name  = "2 Cores (testing only)"
    value = "2"
  }
  option {
    name  = "4 Cores (light editing)"
    value = "4"
  }
  option {
    name  = "8 Cores (recommended)"
    value = "8"
  }
  option {
    name  = "12 Cores (XR + 3D)"
    value = "12"
  }
  option {
    name  = "16 Cores (heavy workload)"
    value = "16"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory in GB (16 GB minimum for XR emulator)"
  default      = "16"
  type         = "number"
  mutable      = true

  option {
    name  = "4 GB (testing only)"
    value = "4"
  }
  option {
    name  = "8 GB (light editing)"
    value = "8"
  }
  option {
    name  = "16 GB (recommended)"
    value = "16"
  }
  option {
    name  = "24 GB (XR + 3D)"
    value = "24"
  }
  option {
    name  = "32 GB (heavy workload)"
    value = "32"
  }
}

data "coder_parameter" "disk_size" {
  name         = "disk_size"
  display_name = "Disk Size"
  description  = "The size of the disk in GB"
  default      = "50"
  type         = "number"
  mutable      = false

  option {
    name  = "30 GB"
    value = "30"
  }
  option {
    name  = "50 GB"
    value = "50"
  }
  option {
    name  = "100 GB"
    value = "100"
  }
}

data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  arch           = "amd64"
  os             = "linux"
  startup_script = file("./build.sh")

  # Display apps
  display_apps {
    vscode          = true
    vscode_insiders = false
    web_terminal    = true
    port_forwarding_helper = true
    ssh_helper      = true
  }

  metadata {
    display_name = "CPU Usage"
    key          = "cpu"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "ram"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Disk Usage"
    key          = "disk"
    script       = "coder stat disk --path /home/coder"
    interval     = 600
    timeout      = 30
  }
}

resource "coder_app" "antigravity" {
  agent_id     = coder_agent.main.id
  slug         = "antigravity"
  display_name = "Antigravity IDE"
  icon         = "https://www.gstatic.com/images/branding/product/2x/antigravity_48dp.png"
  url          = "http://localhost:13337"
  subdomain    = true
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "android_studio" {
  agent_id     = coder_agent.main.id
  slug         = "android-studio"
  display_name = "Android Studio"
  icon         = "https://developer.android.com/studio/images/studio-icon.svg"
  command      = "/snap/bin/android-studio"
}

resource "docker_image" "main" {
  name = "antigravity-xr-workspace"
  build {
    context    = "./build"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.name
  name  = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"

  # CPU and Memory
  cpu_shares = data.coder_parameter.cpu.value * 1024
  memory     = data.coder_parameter.memory.value * 1024

  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }

  # Expose Antigravity port
  ports {
    internal = 13337
    external = 13337
  }

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/home/coder"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "ANDROID_HOME=/home/coder/Android/Sdk",
    "ANDROID_SDK_ROOT=/home/coder/Android/Sdk"
  ]
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-home"
}

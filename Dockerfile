# --- Builder Stage ---
FROM debian:bookworm as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    automake \
    autoconf \
    libtool \
    pkgconf \
    gettext \
    git

# Clone and build Neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    git checkout stable && \
    make CMAKE_BUILD_TYPE=Release && \
    make DESTDIR=/usr/local/nvim install

# --- Final Stage ---
FROM debian:bookworm-slim

# Set environment variables
ENV EDITOR=nvim
ENV VISUAL=nvim

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    ripgrep \
    fd-find \
    fzf \
    nodejs \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy Neovim from the builder stage
COPY --from=builder /usr/local/nvim/usr/local /usr/local

# Download and install Lazygit
RUN curl -L https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz | tar -xz -C /usr/local/bin lazygit

# Clone the LazyVim starter repository
RUN git clone https://github.com/LazyVim/starter.git /root/.config/nvim

# Mark the /work directory as safe for git
RUN git config --global --add safe.directory /work

# Pre-install all the plugins
RUN nvim --headless -c 'Lazy sync' -c 'qa'

# Set the default command to run Neovim
CMD ["nvim"]

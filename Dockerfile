# Use the latest Ubuntu image
FROM ubuntu:latest

# Set non-interactive mode during the build
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade packages, install required tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl wget python3 git gcc g++ cmake libtool autoconf zsh neovim vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    sed -i "s#ZSH_THEME=.*#ZSH_THEME='powerlevel10k/powerlevel10k'#g" ~/.zshrc

# Install Zsh Autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

COPY ./.zshrc /root/
COPY ./.p10k.zsh /root/

# Set the default shell to Zsh
SHELL ["/bin/zsh", "-c"]

# Set the working directory
WORKDIR /root/workspace

# Default command
CMD ["/bin/zsh"]

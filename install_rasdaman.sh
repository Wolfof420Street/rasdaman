#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew first:"
    echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install required dependencies
echo "Installing dependencies..."
brew install postgresql@13
brew install gdal
brew install netcdf
brew install hdf5

# Start PostgreSQL
echo "Starting PostgreSQL..."
brew services start postgresql@13

# Create database and user
echo "Creating database and user..."
createdb rasdaman
createuser -s rasdaman
psql -d rasdaman -c "ALTER USER rasdaman WITH PASSWORD 'rasdaman';"

# Download and install Rasdaman
echo "Downloading Rasdaman..."
curl -L -o rasdaman.deb https://download.rasdaman.org/packages/rasdaman-10.0.0.deb

echo "Installing Rasdaman..."
sudo dpkg -i rasdaman.deb
sudo apt-get install -f

# Clean up
rm rasdaman.deb

echo "Rasdaman has been installed successfully!"
echo "You can start the service with: sudo systemctl start rasdaman"
echo "You can check the status with: sudo systemctl status rasdaman" 
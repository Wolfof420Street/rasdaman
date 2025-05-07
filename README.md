# HDF5 to Rasdaman Import Tool

This tool helps you create ingredient files for importing multiple HDF5 data files into Rasdaman.

## Prerequisites

1. Python 3.8 or higher
2. Rasdaman server installed and running

## Installation

### Automatic Setup (Recommended)

1. Run the setup script:
```bash
./setup.sh
```

This will:
- Create a Python virtual environment
- Install all required dependencies
- Create the data directory

### Manual Setup

If you prefer to set up manually:

1. Create and activate a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install the required dependencies:
```bash
pip install -r requirements.txt
```

3. Create a data directory:
```bash
mkdir data
```

## Usage

1. Activate the virtual environment (if not already activated):
```bash
source venv/bin/activate
```

2. Place your HDF5 files in the `data` directory

3. Run the script:
```bash
python hdf5_to_rasdaman.py
```

4. The script will:
   - Find all HDF5 files in the `data` directory
   - Create an `ingredient_files` directory
   - Generate an ingredient file for each HDF5 file
   - Name each coverage based on the original filename

5. Import all files into Rasdaman using:
```bash
cd ingredient_files
for f in *_ingredient.json; do wcst_import.sh $f; done
```

## Notes

- The script currently uses EPSG:4326 (WGS84) as the default coordinate reference system. You may need to modify this in the script if your data uses a different CRS.
- Make sure your HDF5 files are properly formatted and contain the expected datasets.
- The script will create metadata based on the HDF5 file names and import timestamps.
- Each HDF5 file will be imported as a separate coverage in Rasdaman.

## Troubleshooting

If you encounter any issues:
1. Ensure your HDF5 files are valid and accessible in the `data` directory
2. Make sure you're running the script within the virtual environment
3. Verify that your Rasdaman server is running
4. Check the permissions of your input and output files
5. If a specific file fails to process, the script will continue with the remaining files 
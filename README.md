# HDF5 to Rasdaman Import Tool

This tool helps you import HDF5 files into Rasdaman, a powerful array database system for managing and analyzing large-scale raster data.

## Prerequisites

- Python 3.8 or higher
- Docker and Docker Compose (for running Rasdaman locally)
- GDAL (will be installed via requirements.txt)

## Setup

1. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Create a data directory for your HDF5 files:
```bash
mkdir -p data
```

## Running Rasdaman Locally

1. Start Rasdaman services:
```bash
./start_rasdaman.sh start
```

2. Check service status:
```bash
./start_rasdaman.sh status
```

3. View service logs:
```bash
./start_rasdaman.sh logs
```

4. Stop services when done:
```bash
./start_rasdaman.sh stop
```

The Rasdaman services will be available at:
- Rasdaman: http://localhost:8080/rasdaman/ows
- Petascope: http://localhost:8081/petascope/ows

Default credentials:
- Username: rasadmin
- Password: rasadmin

## Usage

1. Place your HDF5 files in the `data` directory.

2. Run the script:
```bash
python hdf5_to_rasdaman.py
```

Optional arguments:
- `--rasdaman-url`: Specify Rasdaman server URL (default: http://localhost:8080/rasdaman/ows)
- `--skip-import`: Skip importing to Rasdaman (only create ingredient files)
- `--data-dir`: Specify data directory (default: data)

Example:
```bash
python hdf5_to_rasdaman.py --rasdaman-url http://localhost:8080/rasdaman/ows --data-dir /path/to/data
```

## Output

- Ingredient files will be created in the `ingredient_files` directory
- Each HDF5 file will have a corresponding JSON ingredient file
- The script will attempt to import the data into Rasdaman

## Troubleshooting

1. If Rasdaman is not responding:
   - Check if services are running: `./start_rasdaman.sh status`
   - View logs: `./start_rasdaman.sh logs`
   - Restart services: `./start_rasdaman.sh restart`

2. If import fails:
   - Check the ingredient files in the `ingredient_files` directory
   - Verify the HDF5 file format and structure
   - Check Rasdaman logs for detailed error messages

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
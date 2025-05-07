import h5py
import numpy as np
from osgeo import gdal
import os
import json
from datetime import datetime
import glob
import requests
import base64

def create_ingredient_file(hdf5_path, output_path, coverage_name):
    """
    Create a Rasdaman ingredient file for HDF5 data
    """
    with h5py.File(hdf5_path, 'r') as f:
        # Get the first dataset to determine dimensions
        first_dataset = list(f.keys())[0]
        data = f[first_dataset]
        
        # Create ingredient file structure
        ingredient = {
            "coverage": {
                "name": coverage_name,
                "metadata": {
                    "type": "json",
                    "global": {
                        "Title": f"Coverage from {os.path.basename(hdf5_path)}",
                        "Description": f"Imported from HDF5 file on {datetime.now().isoformat()}",
                        "Source": hdf5_path
                    }
                },
                "slicer": {
                    "type": "gdal",
                    "options": {
                        "format": "HDF5",
                        "path": hdf5_path
                    }
                },
                "crs": {
                    "type": "EPSG",
                    "code": 4326  # Default to WGS84, adjust as needed
                },
                "metadata": {
                    "type": "json",
                    "global": {
                        "Title": f"Coverage from {os.path.basename(hdf5_path)}",
                        "Description": f"Imported from HDF5 file on {datetime.now().isoformat()}",
                        "Source": hdf5_path
                    }
                }
            }
        }
        
        # Write ingredient file
        with open(output_path, 'w') as outfile:
            json.dump(ingredient, outfile, indent=2)
        
        print(f"Ingredient file created at: {output_path}")
        return ingredient

def import_to_rasdaman(ingredient_file, rasdaman_url="http://localhost:8080/rasdaman/ows"):
    """
    Import coverage to Rasdaman using REST API
    """
    try:
        # Read the ingredient file
        with open(ingredient_file, 'r') as f:
            ingredient = json.load(f)
        
        # Prepare the request
        headers = {
            'Content-Type': 'application/json'
        }
        
        # Send the request to Rasdaman
        response = requests.post(
            f"{rasdaman_url}/import",
            json=ingredient,
            headers=headers
        )
        
        if response.status_code == 200:
            print(f"Successfully imported coverage: {ingredient['coverage']['name']}")
            return True
        else:
            print(f"Failed to import coverage. Status code: {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"Error importing to Rasdaman: {str(e)}")
        return False

def process_data_directory(data_dir):
    """
    Process all HDF5 files in the specified directory
    """
    # Find all HDF5 files in the directory
    hdf5_files = glob.glob(os.path.join(data_dir, "*.h5")) + \
                 glob.glob(os.path.join(data_dir, "*.hdf5")) + \
                 glob.glob(os.path.join(data_dir, "*.h5"))
    
    if not hdf5_files:
        print(f"No HDF5 files found in {data_dir}")
        return
    
    print(f"Found {len(hdf5_files)} HDF5 files")
    
    # Create output directory for ingredient files
    output_dir = "ingredient_files"
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each file
    for hdf5_file in hdf5_files:
        try:
            # Create coverage name from filename
            base_name = os.path.splitext(os.path.basename(hdf5_file))[0]
            coverage_name = f"{base_name}_coverage"
            output_path = os.path.join(output_dir, f"{coverage_name}_ingredient.json")
            
            print(f"\nProcessing: {hdf5_file}")
            ingredient = create_ingredient_file(hdf5_file, output_path, coverage_name)
            
            # Import to Rasdaman
            print(f"Importing to Rasdaman: {coverage_name}")
            import_to_rasdaman(output_path)
            
        except Exception as e:
            print(f"Error processing {hdf5_file}: {str(e)}")
            continue

def main():
    # Use the data directory in the current folder
    data_dir = "data"
    
    if not os.path.exists(data_dir):
        print(f"Data directory '{data_dir}' not found!")
        return
    
    try:
        process_data_directory(data_dir)
        print("\nProcessing complete!")
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    main() 
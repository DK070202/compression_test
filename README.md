# Project: Data Compression Tests

This project includes tests for compressing and decompressing various data types, including JSON data with short and complete key names, and raw byte data.

## Test Summary

The following table presents the results of three compression tests:

| **Test Name**                    | **Original Size (MB)** | **Compressed Size (MB)** | **Decompressed Size (MB)** | **Compression Percentage** |
|-----------------------------------|------------------------|--------------------------|----------------------------|----------------------------|
| **json with short key names**     | 3.29                   | 0.28                     | 3.29                       | 91.53%                     |
| **byte**                          | 0.67                   | 0.08                     | 0.67                       | 88.43%                     |
| **json with complete key names**  | 3.45                   | 0.28                     | 3.45                       | 92.51%                     |

## Key Concepts
- **Compression**: The process of reducing the size of data to save storage space or transmission bandwidth.
- **Decompression**: The process of restoring compressed data back to its original size.
- **Compression Percentage**: A measure of how much the data size has been reduced after compression.

## How to Run
1. Clone the repository.
2. Ensure you have Dart installed.
3. Run the Dart script to test the compression and decompression functionality.
4. Check the results printed to the console.

# GloSIS Web Mapping Application

This is a web mapping application for the GloSIS project, built with OpenLayers.

## Features

- Interactive map interface
- Layer switcher with collapsible groups
- Support for WMS layers
- Opacity control
- Scale display and zoom controls
- Metadata and download links for each layer

## Prerequisites

- Node.js (v14 or higher)
- npm or yarn

## Installation

```bash
# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build
```

## Docker

You can also run this application using Docker:

```bash
# Build the Docker image
docker build -t glosis-wm .

# Run the container
docker run -p 1234:1234 -v $(pwd):/app glosis-wm
```

## Project Structure

```
glosis-wm/
├── public/               # Static files
├── src/                  # Source files
│   ├── css/              # Stylesheets
│   ├── img/              # Images
│   ├── js/               # JavaScript files
│   └── index.html        # Main HTML file
├── Dockerfile            # Docker configuration
├── package.json          # Dependencies and scripts
└── README.md             # This file
```

## Layer Configuration

The application reads layer configuration from `layer_info.csv`, which contains details for each layer including:
- Layer group
- Layer ID
- Property information
- Metadata URL
- Download URL
- WMS endpoints 
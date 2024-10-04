#!/bin/bash

# Get the solution name from the user (or use a default)
read -p "Enter solution name (or press Enter to use 'MySolution'): " solution_name
solution_name=${solution_name:-MySolution}

# Create the root solution directory
mkdir "$solution_name"
cd "$solution_name"

# Create the main project directories
mkdir src tests docs

# Create the Core project
dotnet new classlib -o "src/$solution_name.Core"
cd "src/$solution_name.Core"
mkdir Models Services Interfaces
cd ../..  # Navigate back to the solution root

# Create the Infrastructure project
dotnet new classlib -o "src/$solution_name.Infrastructure"
cd "src/$solution_name.Infrastructure"
mkdir Data Repositories
cd ../..  # Navigate back to the solution root

# Create the App project (assuming console app)
dotnet new console -o "src/$solution_name.App"

# Create corresponding test projects (adjust if using different test framework)
dotnet new mstest -o "tests/$solution_name.Core.Tests"
dotnet new mstest -o "tests/$solution_name.Infrastructure.Tests"

# Create the solution file and add the projects
dotnet new sln
dotnet sln add "src/$solution_name.Core/$solution_name.Core.csproj"
dotnet sln add "src/$solution_name.Infrastructure/$solution_name.Infrastructure.csproj"
dotnet sln add "src/$solution_name.App/$solution_name.App.csproj"
dotnet sln add "tests/$solution_name.Core.Tests/$solution_name.Core.Tests.csproj"
dotnet sln add "tests/$solution_name.Infrastructure.Tests/$solution_name.Infrastructure.Tests.csproj"

echo "Solution structure created successfully!"
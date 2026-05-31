# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project files
COPY ["ContactKeeper/ContactKeeper.csproj", "ContactKeeper/"]
COPY ["ContactKeeper.Test/ContactKeeper.Test.csproj", "ContactKeeper.Test/"]

# Restore dependencies
RUN dotnet restore "ContactKeeper/ContactKeeper.csproj"

# Copy source and publish
COPY . .
WORKDIR "/src/ContactKeeper"
RUN dotnet publish "ContactKeeper.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .

# Expose port
EXPOSE 80

# Start application
ENTRYPOINT ["dotnet", "ContactKeeper.dll"]
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy e restore
COPY ["Functions.csproj", "./"]
RUN dotnet restore "Functions.csproj"

# Copy source e publish
COPY . .
RUN dotnet publish "Functions.csproj" -c Release -o /app/publish --no-restore

# Runtime stage — imagem correta para Azure Functions isolated
FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated9.0
WORKDIR /home/site/wwwroot

COPY --from=build /app/publish .

ENV AzureWebJobsScriptRoot=/home/site/wwwroot
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true

EXPOSE 80
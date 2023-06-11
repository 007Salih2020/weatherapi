# Get Base Image (Full .NET Core SDK)
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy csproj and restore
COPY weatherapi.csproj ./
RUN dotnet restore "weatherapi.csproj" --use-current-runtime  

# Copy everything else and build
COPY . .
# RUN dotnet publish --use-current-runtime --self-contained false --no-restore -o out

RUN dotnet publish "weatherapi.csproj"   -c Release -o /app/build   

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
EXPOSE 80
COPY --from=build-env  /app/build .
ENTRYPOINT ["dotnet", "weatherapi.dll"]
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
EXPOSE 8080
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["AttendanceCRM/AttendanceCRM.csproj", "AttendanceCRM/"]
RUN dotnet restore "AttendanceCRM/AttendanceCRM.csproj"
COPY . .
WORKDIR "/src/AttendanceCRM"
RUN dotnet build "AttendanceCRM.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
WORKDIR "/src/AttendanceCRM"
RUN dotnet publish "AttendanceCRM.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
CMD ["dotnet", "AttendanceCRM.dll"]
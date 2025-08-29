FROM mcr.microsoft.com/windows/nanoserver:ltsc2022
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Invoke-WebRequest -UseBasicParsing -Uri https://nodejs.org/dist/v18.17.0/node-v18.17.0-win-x64.zip -OutFile node.zip; \
    Expand-Archive node.zip -DestinationPath C:\; \
    Rename-Item 'C:\node-v18.17.0-win-x64' c:\nodejs; \
    Remove-Item -Force node.zip
ENV PATH="C:\nodejs;$env:PATH"
WORKDIR /app
COPY package.json .
ARG NODE_ENV=development
RUN if ($env:NODE_ENV -eq 'production') { npm install --only=production } else { npm install }
COPY . .
EXPOSE 4000
CMD ["npm", "run", "start-dev"]
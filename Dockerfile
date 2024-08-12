# 使用官方 Node.js 镜像作为构建基础镜像
FROM node:18.17.1 AS builder

# 安装 pnpm
RUN npm install -g pnpm@8.7.0

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 pnpm-lock.yaml（如果有的话）到工作目录
COPY package*.json pnpm-lock.yaml* ./

# 安装应用依赖
RUN pnpm install

# 复制应用源代码到工作目录
COPY . .

# 构建应用
RUN pnpm run build

# 使用 Nginx 镜像作为生产环境镜像
FROM nginx:alpine

# 将构建产物从 /app/dist 复制到 Nginx 的默认服务目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口 80
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]

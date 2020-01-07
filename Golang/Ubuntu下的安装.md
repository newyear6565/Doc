1、 安装GO

sudo apt-get install golang-go

查询某个命令(go命令)路径
whereis go

2、 设置Go环境变量

输入go env查看变量

打开终端，输入命令：

export GOROOT=$HOME/go

export PATH=$GOROOT/bin:$PAT

GOROOT解压的位置

GOPATH 工作区目录

GOBIN install的目录

PATH  命令目录


找不到godoc(直接下载的不需要这个)

sudo apt install golang-golang-x-tools

3、 设置go代码目录

sudo mkdir Applications/go

4、 测试安装

完成安装后，新建一个文档来测试环境是否搭建成功:

Example helloWorld.go

复制代码
package main

    import (
        "fmt"
         "runtime"
    )

    func main() {
        fmt.Println("Hellow World!", runtime.Version())
    }    
复制代码
执行go run helloWorld.go, 应该会打印出：

或者go build helloWorld.go，将生成helloWorld.sh，./helloWorld也可以运行。


### 配置代理

启用 Go Modules 功能

export GO111MODULE=on

配置 GOPROXY 环境变量

export GOPROXY=https://goproxy.io


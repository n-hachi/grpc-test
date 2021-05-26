grpc-test
---

# 概要
grpcリポジトリのサンプルアプリの動作確認用リポジトリ <br>

# 手順
1. dockerイメージを作成する
```bash
$ docker build -t ubuntu_grpc_test .
```
2. サーバを動かす
```sh
$ docker run --name server --net host --rm -it ubuntu_grpc_test
> cd grpc/examples/cpp/route_guide/cmake/build
> ./route_guide_server
```
3. クライアントを動かす
サーバが動作していない別の端末を立ち上げる。<br>
以降は新しい端末上で実行する。
```sh
$ docker run --name client --net host --rm -it ubuntu_grpc_test
> cd grpc/examples/cpp/route_guide/cmake/build
> ./route_guide_client
```


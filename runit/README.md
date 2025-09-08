## runit

### 使用

#### 新建镜像

```dockerfile
FROM jinnlynn/runit AS runit

FROM jinnlynn/alpine

COPY --from=runit /app/opt/runit/ /app/opt/runit/
COPY --from=runit /app/bin/runit-init /app/bin/

RUN set -ex && \
    ...

ENTRYPOINT ["runit-init"]

```



```shell
# SERVICE FILE: /app/etc/service.d/example/run
. /app/opt/runit/sv.rc
exec echo "runit example"
```

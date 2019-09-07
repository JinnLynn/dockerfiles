# REF: https://git-scm.com/docs/gitweb.conf

# 项目目录
$projectroot = "${PROJECT_ROOT}";

# @git_base_url_list = ('http://127.0.0.1:8888');


# 代码高亮
$feature{'highlight'}{'default'} = [${FEATURE_HIGHLIGHT}];
# 搜索
$feature{'search'}{'default'} = [${FEATURE_SEARCH}];
# 头像服务
$feature{'avatar'}{'default'} = ['${FEATURE_AVATAR}'];
# blame
$feature{'blame'}{'default'} = [${FEATURE_BLAME}];
# 快照下载
# 若允许 设置为压缩格式 支持: tgz, tbz2, txz, zip
# 不允许 设为none
$feature{'snapshot'}{'default'} = ['${FEATURE_SNAPSHOT}'];

$feature{'timed'}{'default'} = [1];

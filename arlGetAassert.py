import optparse
import requests
# 这个apikey是灯塔里面之前在config-docker.yaml里面配置的灯塔的认证key
apikey = "t44y56c-xxxx-xxxx-xxxx-xxxxxxxxxxx"
requests.packages.urllib3.disable_warnings()


def print_hi(name):
    print(f'Hi, {name}')  # 示例函数，未被调用


def task(scope_id):
    headers = {'accept': 'application/json', 'Token': apikey}  # 请求头

    # 首次请求获取总条数
    ceshi = requests.get(
        "https://IP:5003/api/asset_domain/?size=100&tabIndex=1&scope_id=" + scope_id,
        headers=headers,
        verify=False  # 关闭SSL验证（存在安全风险！）
    )
    json1 = ceshi.json()
    number = json1['total']  # 总数据量
    pages = number // 100  # 计算总页数（每页100条）
    pages += 1

    # 分页循环获取数据
    for page in range(1, pages + 1):
        data = requests.get(
            f"https://IP:5003/api/asset_domain/?page={page}&size=100&tabIndex=1&scope_id={scope_id}",
            headers=headers,
            verify=False
        )
        json_data = data.json()
        items = json_data['items']  # 当前页的数据列表

        # 遍历并打印每个站点的名称
        for item in items:
            print("%s" % (item['domain']))


if __name__ == '__main__':
    # 参数帮助信息
    parser = optparse.OptionParser(
        'python3 arlGetAassert.py -s scope_id -o result.txt\n'
        'Example: python3 arlGetAassert.py -s 6229835c322616001dd91fe4\n'
    )

    # 定义 -s 参数（资产范围ID）
    parser.add_option(
        '-s', dest='scope_id', default='6229835c322616001dd91fe4',
        type='string', help='scope_id 资产范围ID'
    )

    # 解析参数并调用任务函数
    (options, args) = parser.parse_args()
    task(options.scope_id)

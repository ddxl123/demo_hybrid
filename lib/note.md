1. 工具 util 可以嵌套工具来使用，但每个工具内部之间不能存在依赖关系。
2. 工具 util 和 全局的（例如悬浮球）的状态管理不能使用外部依赖，比如 GetX、Provider 等。
3. SbHelper 类可以用外部依赖。

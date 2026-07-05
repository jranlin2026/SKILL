# Settlement Rules

## Required And Optional Inputs

Required:

```text
订单明细表
资金流水明细表
```

Optional:

```text
商品成本明细表
运费险明细表
```

If `商品成本明细表` is absent, set product cost to 0. If `运费险明细表` is absent, set freight insurance fee to 0.

## Output Workbook

Create a single workbook with exactly these business sheets:

```text
订单明细融合表
达人结算汇总表
资金流水总览
资金流水场景汇总
资金流水月份汇总
资金流水明细核对
```

Do not split fund-flow summary into a second downloadable workbook unless the user explicitly asks for a separate fund-flow export.

## Order Detail Merge Sheet

Output fields:

```text
订单月份
主订单编号
子订单编号
结算到账金额
运费险
商品数量
商家编码
商品单价
订单应付金额
产品单件成本
产品总成本
订单提交时间
订单完成时间
支付完成时间
达人ID
达人昵称
发货时间
```

Rules:

```text
订单月份 = 订单提交时间的月份，YYYY-MM
达人昵称为空 -> 商品卡流量
达人昵称为空时，达人ID 留空
```

Settlement amount:

```text
结算到账金额 = 资金流水入账金额 - 资金流水出账金额
入账为正，出账为负
```

Fund-flow matching:

```text
资金流水有 子订单号 -> 只匹配 订单明细表.子订单编号
资金流水 子订单号 为空 -> 用 资金流水.订单号 匹配 订单明细表.主订单编号
不要用一个子订单流水覆盖同一主订单下其他子订单
```

Freight insurance:

```text
只统计 保费状态 = 已扣减
运费险明细表.订单编号 只匹配 订单明细表.子订单编号
不要用 主订单编号 兜底匹配运费险
没有运费险明细表 -> 运费险费用为 0
```

Product cost:

```text
订单明细表.商家编码 = 商品成本明细表.商家编码
产品单件成本 = 商品成本明细表.商品单价
结算到账金额 > 5 时：产品总成本 = 产品单件成本 * 商品数量
结算到账金额 <= 5 或为空时：产品总成本按空值/0处理
没有商品成本明细表 -> 产品成本为 0
```

## Talent Settlement Summary Sheet

Group by:

```text
订单月份 + 达人昵称 + 达人ID
```

Output fields:

```text
订单月份
达人昵称
达人ID
实付订单金额
实付订单数
快递包裹数
快递费用
运费险费用
结算到账金额
产品成本
成本总额
毛利润
销售额毛利率
```

Paid GMV:

```text
Only rows with 支付完成时间 non-empty count.

实付订单金额 =
订单应付金额
+ 平台实际承担优惠金额
+ 商家实际承担优惠金额
+ 达人实际承担优惠金额
```

Paid order count:

```text
实付订单数 = 去重子订单编号数 where 支付完成时间 non-empty
```

Package count:

```text
只统计 发货时间 非空的订单
按 订单月份 + 达人昵称 + 达人ID + 主订单编号 + 发货时间 去重
每个唯一组合算 1 个快递包裹
```

Courier cost:

```text
快递费用 = 快递包裹数 * 2.4
```

Freight insurance summary:

```text
有运费险明细表时：
只统计 保费状态 = 已扣减 的支付保费
订单编号 只匹配 子订单编号
按匹配到的 订单月份 + 达人昵称 + 达人ID 汇总

没有运费险明细表时：
运费险费用 = 0
```

Settlement summary:

```text
按资金流水实际入账/出账汇总，不看订单状态
正数、负数都保留
```

Product cost summary:

```text
有商品成本明细表时：
产品成本 = 商品单价 * 商品数量
只统计结算到账金额 > 5 的订单行

没有商品成本明细表时：
产品成本 = 0
```

Profit:

```text
成本总额 = 快递费用 + 运费险费用 + 产品成本
毛利润 = 结算到账金额 - 成本总额
销售额毛利率 = 毛利润 / 实付订单金额
实付订单金额为 0 时，销售额毛利率留空
```

## Fund Flow Summary Sheets

The fund-flow summary is included in the same settlement output workbook.

### Common Classification

```text
归类动账场景 = 动账场景
如果 动账场景 为空，则用 备注
如果 动账场景 和 备注 都为空，则归为 未归类
```

Add `归类来源`:

```text
动账场景：原始动账场景不为空
备注兜底：动账场景为空，使用备注
未归类：动账场景和备注都为空
```

Signed amount:

```text
动账方向 = 入账 -> 签名净额 = abs(动账金额)
动账方向 = 出账 -> 签名净额 = -abs(动账金额)
净额 = 入账金额 - 出账金额
```

### 资金流水总览

Include:

```text
流水总笔数
入账笔数
入账金额
出账笔数
出账金额
净额
动账场景为空
备注兜底成功
无订单号流水
覆盖月份
最早动账时间
最晚动账时间
Top动账场景
```

### 资金流水场景汇总

Group by `归类动账场景`.

Columns:

```text
动账场景归类
总笔数
入账笔数
入账金额
出账笔数
出账金额
净额
有订单号笔数
无订单号笔数
备注兜底笔数
最早动账时间
最晚动账时间
```

Sort by absolute `净额` descending, then `总笔数` descending.

### 资金流水月份汇总

Group by:

```text
动账时间 YYYY-MM + 归类动账场景
```

Use the same measure columns as `资金流水场景汇总`, with `月份` as the first column.

### 资金流水明细核对

Keep original fund-flow rows and prepend:

```text
归类动账场景
归类来源
签名净额
```

## Validation

Before returning the workbook:

1. Confirm all six output sheets exist.
2. Confirm `订单明细融合表` and `达人结算汇总表` totals match the settlement algorithm.
3. Confirm `资金流水场景汇总.总笔数` sums to source fund-flow row count.
4. Confirm grouped `入账金额`, `出账金额`, and `净额` equal raw source totals.
5. Confirm `动账场景为空` equals source rows where `动账场景` is blank.
6. Confirm `备注兜底成功` equals blank-scene rows with non-empty `备注`.
7. Scan the workbook for spreadsheet errors such as `#REF!`, `#DIV/0!`, `#VALUE!`, `#NAME?`, and `#N/A`.

## Confirmed Regression Sample

For `风华服饰时尚小铺` May 2026:

```text
订单表总行数：45372
订单明细融合表运费险合计：16052.93
订单明细融合表产品总成本合计：260110.00
达人结算汇总表实付订单金额合计：3065045.90
达人结算汇总表实付订单数合计：39575
达人结算汇总表快递包裹数合计：25869
达人结算汇总表快递费用合计：62085.60
达人结算汇总表运费险费用合计：16052.93
达人结算汇总表结算到账金额合计：523778.07
达人结算汇总表产品成本合计：260110.00
达人结算汇总表成本总额合计：338248.53
达人结算汇总表毛利润合计：185529.54

资金流水总笔数：12466
入账笔数：8776
入账金额：555498.50
出账笔数：3690
出账金额：542407.89
净额：13090.61
动账场景为空：2
备注兜底成功：2
无订单号流水：3374
资金流水覆盖月份：2026-05, 2026-06
```

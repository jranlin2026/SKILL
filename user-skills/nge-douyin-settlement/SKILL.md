---
name: nge-douyin-settlement
description: NGE-Douyin-Settlement creates Douyin shop settlement output workbooks from exported order detail and fund flow spreadsheets, with optional product cost and freight insurance sheets. Use when the user asks to calculate Douyin shop/talent settlement, generate 结算输出表, 订单明细融合表, 达人结算汇总表, or include fund-flow audit sheets such as 资金流水总览、资金流水场景汇总、资金流水月份汇总、资金流水明细核对.
---

# NGE-Douyin-Settlement

Use this skill to generate the standard Douyin shop settlement workbook.

## Standard Output

Generate one Excel workbook named like:

```text
结算输出表.xlsx
{店铺名}-结算输出表.xlsx
```

The workbook must contain these business sheets, in this order:

```text
订单明细融合表
达人结算汇总表
资金流水总览
资金流水场景汇总
资金流水月份汇总
资金流水明细核对
```

`订单明细融合表` is the order-row trace table. `达人结算汇总表` is the final talent profit settlement table. The four `资金流水...` sheets are fund-flow audit sheets for tracing settlement amounts back to the original fund-flow export.

## Inputs

Require these two files:

```text
抖店导出的订单明细表
抖店导出的资金流水明细表
```

Accept these optional files:

```text
商品成本明细表
运费险明细表
```

If the product cost sheet is missing, calculate product cost as `0`. If the freight insurance sheet is missing, calculate freight insurance fee as `0`.

## Workflow

1. Read `references/settlement-rules.md` before calculating.
2. Inspect source workbook columns instead of assuming platform exports are stable.
3. Keep only the fields needed by the settlement algorithm; ignore unrelated added export columns.
4. Validate the two required table types where possible: order detail must look like an order export, and fund flow must look like a fund-flow export.
5. Build `订单明细融合表` from the order detail sheet as the main trace table.
6. Build `达人结算汇总表` grouped by `订单月份 + 达人昵称 + 达人ID`.
7. Build fund-flow audit sheets from the fund-flow sheet:
   - `资金流水总览`
   - `资金流水场景汇总`
   - `资金流水月份汇总`
   - `资金流水明细核对`
8. Export all six sheets into one workbook.
9. Verify the key totals, especially 运费险费用、产品成本、结算到账金额、成本总额、毛利润, and fund-flow 入账金额、出账金额、净额.

## Critical Rules

- Do not use order status to decide settlement. Settlement amount comes from actual fund flow only.
- Fund flow with `子订单号` can only match order `子订单编号`.
- Only when fund flow `子订单号` is blank may fund flow `订单号` match order `主订单编号`.
- Fund-flow scene classification uses `动账场景`; if it is blank, use `备注`.
- Fund-flow signed amount: `入账` is positive, `出账` is negative.
- Freight insurance only counts rows where `保费状态 = 已扣减`.
- Freight insurance `订单编号` only matches order `子订单编号`; do not fall back to `主订单编号`.
- Empty `达人昵称` becomes `商品卡流量`; when nickname is empty, `达人ID` is blank.
- Product cost only uses the product cost sheet. Match by `商家编码`.
- Product cost is counted only for order rows whose `结算到账金额 > 5`.
- Default courier cost is `2.4` per package unless the user gives another value.

## Fund-Flow Output Rules

The fund-flow audit sheets must follow the companion rules from `NGE-Douyin-Flow-Settlement`:

- `资金流水总览`: total rows, income count/amount, outgoing count/amount, net amount, blank scene count, remark fallback count, no-order fund-flow count, covered months, first/last fund-flow time, and top scenes.
- `资金流水场景汇总`: group by classified `动账场景`.
- `资金流水月份汇总`: group by `YYYY-MM + classified 动账场景`.
- `资金流水明细核对`: keep original fund-flow rows and prepend `归类动账场景`、`归类来源`、`签名净额`.

## Verification Targets

For the confirmed `风华服饰时尚小铺` May 2026 sample, expected settlement totals include:

```text
订单明细融合表行数：45372
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
```

Expected fund-flow totals for that same sample:

```text
资金流水总笔数：12466
入账笔数：8776
入账金额：555498.50
出账笔数：3690
出账金额：542407.89
净额：13090.61
动账场景为空：2
备注兜底成功：2
无订单号流水：3374
覆盖月份：2026-05, 2026-06
```

Use these only as regression checks for that sample, not as constants for other shops or months.

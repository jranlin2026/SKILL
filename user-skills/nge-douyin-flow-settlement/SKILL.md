---
name: nge-douyin-flow-settlement
description: NGE-Douyin-Flow-Settlement creates a clear Douyin shop fund-flow summary workbook from exported 资金流水明细 .xlsx/.csv files. Use when the user asks to summarize 抖店资金流水, group by 动账场景, use 备注 when 动账场景 is blank, generate 资金流水汇总表, or audit fund-flow income/outgoing/net amounts.
---

# NGE-Douyin-Flow-Settlement

Use this skill to turn a Douyin shop `资金流水明细` export into a visual, auditable fund-flow summary workbook.

## Standard Output

Generate one Excel workbook named like:

```text
{店铺名}-资金流水汇总表.xlsx
```

The workbook should contain these sheets:

```text
总览
按动账场景汇总
按月份场景汇总
流水明细核对
```

## Input

Accept one required file:

```text
抖店导出的资金流水明细表
```

The source workbook may contain extra sheets or changing platform export columns. Inspect the workbook first and select the non-empty sheet containing the core fund-flow columns.

Core columns:

```text
动账时间
动帐流水号
动账方向
动账金额
动账账户
动账场景
子订单号
订单号
备注
```

Do not fail just because unrelated export columns are added or removed.

## Core Rules

- `归类动账场景 = 动账场景` after trimming whitespace.
- If `动账场景` is blank, use `备注` as `归类动账场景`.
- If both `动账场景` and `备注` are blank, classify as `未归类`.
- Add `归类来源`:
  - `动账场景` when the original scene is present.
  - `备注兜底` when the scene is blank and remark is used.
  - `未归类` when both are blank.
- Calculate signed net amount:
  - `动账方向 = 入账` -> `签名净额 = abs(动账金额)`.
  - `动账方向 = 出账` -> `签名净额 = -abs(动账金额)`.
  - Unknown direction -> keep the raw amount and flag during review.
- `净额 = 入账金额 - 出账金额`.
- `有订单号笔数` means either `子订单号` or `订单号` is non-empty.
- `无订单号笔数` means both `子订单号` and `订单号` are empty.
- Month grouping uses `动账时间` formatted as `YYYY-MM`.

## Sheet Specs

### 总览

Include a compact dashboard with:

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

### 按动账场景汇总

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

### 按月份场景汇总

Group by `月份 + 归类动账场景`.

Use the same measure columns as `按动账场景汇总`, with `月份` as the first column.

### 流水明细核对

Keep the original fund-flow detail rows for audit, with these columns prepended:

```text
归类动账场景
归类来源
签名净额
```

Then append all original source columns in their original order.

## Verification

Before returning the workbook:

1. Check that `按动账场景汇总.总笔数` sums to the source fund-flow row count.
2. Check that grouped `入账金额`, `出账金额`, and `净额` equal raw source totals.
3. Check that `动账场景为空` equals rows where source `动账场景` is blank.
4. Check that `备注兜底成功` equals blank-scene rows with non-empty `备注`.
5. Render or inspect at least `总览` and `按动账场景汇总` to ensure the workbook is readable.
6. Scan for spreadsheet errors such as `#REF!`, `#DIV/0!`, `#VALUE!`, `#NAME?`, and `#N/A`.

## Formatting Guidance

- Freeze header rows on summary/detail sheets.
- Use table filters for grouped sheets and detail audit sheet.
- Format money columns as `#,##0.00`.
- Format count columns as `#,##0`.
- Keep the sheet visually direct: readable headers, clear widths, no unnecessary decoration.

## Confirmed Sample Check

For `风华服饰时尚小铺-资金流水.xlsx`, the confirmed totals are:

```text
流水总笔数：12466
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

# Registered Community license — folders, Debug in editor and custom execution data in n8n

Demo workflow for module 26, the last module of the "Click by Click" series **n8n Training**.
Registering a self-hosted n8n instance (free) gives it a Community license key that unlocks three
features. The video shows all three on a real instance, with a member account:

1. **Folders**: file workflows in folders and subfolders of the personal space, by drag and drop or
   with the "Move" menu of each workflow, and go back up with the breadcrumb;
2. **Debug in editor**: open a failed production execution, copy its data into the editor (pinned on
   the trigger), fix the workflow and run it again with exactly the same data, without waiting for a
   new submission;
3. **Custom execution data**: the **Execution Data** node ("Save Highlight Data") saves a key piece of
   information with each execution — here the name of the user who sent the expense report — shown in
   the execution list ("Highlighted data").

Video: {{video}}

```
Production
  Expense app ──report without amount──▶ Webhook ──▶ Failed execution (data kept)
                                                         │
                                                  Debug in editor
                                                         ▼
Editor
  Pinned data ──fix, run again──▶ Successful execution (same data)
```

## Files

| File | Purpose |
|---|---|
| `workflows/expense-report-intake.json` | The "Expense report intake" workflow **as published at the end of the video**: **Webhook** (`POST /webhook/expense-reports`), **Execution Data** (saves the key `user` from `{{ $json.body.user }}`), **Amount present?** (If: does `body.amount` exist?), **Report recorded** (true branch, status `OK`), **Amount to complete** (false branch, status `Incomplete`, instead of the original Stop and Error) |
| `workflows/expense-report-intake-before.json` | The same workflow **at the start of the demo** (module 9 state): the false branch ends with a **Stop and Error** node "Amount missing", so a report without an amount fails — the execution you replay with Debug in editor |
| `send-report.sh` | Sends an expense report to the production webhook with curl, like the expense app in the video; `--no-amount` sends a report without an amount (failed execution) |
| `.env.example` | Settings of `send-report.sh` (`N8N_URL`, `N8N_WEBHOOK_PATH`) |

## Prerequisites

- **n8n 2.x**, self-hosted (recorded on n8n 2.41.6, Community edition). A member account is enough.
- A **registered Community license** on the instance: the owner opens **Settings › Usage and plan**,
  chooses to register the instance (free, an email address is required) and enters the key received
  by email. The settings then show "Registered Community"; folders and "Debug in editor" become
  available to every account of the instance.
- `curl` and a POSIX shell for `send-report.sh` (on Windows: Git Bash or WSL).

## Step by step

1. **Settings**: `cp .env.example .env`, then set `N8N_URL` to your instance (for example
   `http://localhost:5678`). Keep `N8N_WEBHOOK_PATH=expense-reports` unless that path is already used
   by another published workflow (a production webhook path is unique on an instance).
2. **Import the starting workflow**: in n8n, **Create workflow**, then the "…" menu › **Import from
   File…** › `workflows/expense-report-intake-before.json`. Click **Publish**.
3. **Produce a failed execution**: `./send-report.sh --no-amount`. n8n answers `Workflow was started`
   right away (the Webhook responds immediately), then the execution fails: the report has no amount,
   so the workflow stops on "Stop and Error".
4. **Folders** (optional): in **Personal**, open the create button's menu (arrow next to "Create
   workflow") › **Create folder**; drag a workflow card onto the folder, or use the card menu ›
   **Move**. Open a folder to create a subfolder; the breadcrumb at the top takes you back up.
5. **Debug in editor**: open the workflow, **Executions** tab, click the failed execution, then
   **Debug in editor**. The editor opens with the execution data pinned on the Webhook node.
6. **Fix and replay**: delete "Stop and Error", add an **Edit Fields (Set)** node "Amount to complete"
   on the **false** output of "Amount present?" with a field `status` = `Incomplete`, then click
   **Execute workflow**: it succeeds with the same data.
7. **Custom execution data**: hover the link between "Webhook" and "Amount present?", click **+**,
   choose **Execution Data** (operation "Save Highlight Data"), **Add Saved Field**, key `user`, and
   drag `body › user` from the input panel into **Value** (it becomes `{{ $json.body.user }}`).
8. **Unpin and publish**: open the Webhook node, click the pin to remove the pinned data, close it, and
   click **Publish**. Pinned data only feeds manual runs in the editor; the "Execution data imported"
   notice asks you to unpin it once you are done, so that the next test uses real data.
9. **Send a real report**: `./send-report.sh`. In **Executions**, open the new execution and click
   the badge next to "Copy to editor": **Highlighted data** shows `user: Camille Martin`.

You can also import `workflows/expense-report-intake.json` directly to get the final state.

## Notes

- Filtering the execution list by custom data is announced by the node as reserved for the Pro and
  Enterprise plans; it is not shown in the video.
- Team projects, sharing workflows and credentials, variables and environments require a paid plan.
- The interface of n8n is in English; the video exists in French, English and German, and this
  repository holds the English version of the workflow (the French and German videos use the same
  structure with translated names and keys).

## Series

- Previous module: **The version history of a workflow** (module 25, no repository: nothing to install).
- This is the last module of the n8n series.

## License

MIT (see `LICENSE`). n8n is fair-code software by n8n GmbH (Sustainable Use License); this series is
not affiliated with n8n GmbH.

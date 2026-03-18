// declare the Bun runtime global to satisfy the TypeScript compiler
declare const Bun: any

import { tool } from "@opencode-ai/plugin"

type MrActionsTool = {
  mr_iid: number
}

export const approve = tool({
  description: "Approve a GitLab merge request",
  args: {
    mr_iid: tool.schema.string().describe("Merge request IID (internal ID)"),
  },
  async execute(args: MrActionsTool) {
    const result = await Bun.$`glab mr approve ${args.mr_iid}`.text()
    return result.trim()
  },
})

export const revoke = tool({
  description: "Request changes on a GitLab merge request (revoke approval)",
  args: {
    mr_iid: tool.schema.string().describe("Merge request IID (internal ID)"),
  },
  async execute(args: MrActionsTool) {
    const result = await Bun.$`glab mr revoke ${args.mr_iid}`.text()
    return result.trim()
  },
})

// declare the Bun runtime global to satisfy the TypeScript compiler
declare const Bun: any

import { tool } from "@opencode-ai/plugin"

export const getCurrentUser = tool({
  description: "Get the current authenticated GitLab username",
  args: {},
  async execute() {
    const result = await Bun.$`glab api user`.text()
    const user = JSON.parse(result)
    return user.username
  },
})

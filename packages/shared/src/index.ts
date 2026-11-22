import { z } from "zod";

export const UuidSchema = z.uuid();
export const ServerIdentitySchema = z.object({
  serverId: UuidSchema,
  agentId: UuidSchema,
});
export const AgentStatusSchema = z.enum([
  "provisioning",
  "online",
  "offline",
  "degraded",
  "revoked",
]);
export const HeartbeatSchema = z.object({
  identity: ServerIdentitySchema,
  sequence: z.number().int().nonnegative(),
  sentAt: z.iso.datetime(),
  status: AgentStatusSchema,
});
export const ServerProfileSchema = z.enum(["mix", "competitive"]);
export const ServerCommandSchema = z.object({
  commandId: UuidSchema,
  serverId: UuidSchema,
  sequence: z.number().int().positive(),
  idempotencyKey: z.string().min(16).max(128),
  type: z.enum(["start", "stop", "apply_profile", "collect_status"]),
  issuedAt: z.iso.datetime(),
  expiresAt: z.iso.datetime(),
  payload: z.record(z.string(), z.unknown()).default({}),
});
export const CommandAcknowledgementSchema = z.object({
  commandId: UuidSchema,
  serverId: UuidSchema,
  sequence: z.number().int().positive(),
  status: z.enum(["accepted", "running", "succeeded", "failed", "rejected"]),
  occurredAt: z.iso.datetime(),
  detail: z.string().max(1000).optional(),
});
export const ServerEventSchema = z.object({
  eventId: UuidSchema,
  serverId: UuidSchema,
  agentId: UuidSchema,
  sequence: z.number().int().nonnegative(),
  type: z.string().min(1).max(100),
  occurredAt: z.iso.datetime(),
  payload: z.record(z.string(), z.unknown()),
});
export const MatchSchema = z.object({
  matchId: UuidSchema,
  serverId: UuidSchema,
  profile: ServerProfileSchema,
  format: z.enum(["BO1", "BO3", "BO5"]),
  status: z.enum(["scheduled", "ready", "live", "completed", "cancelled"]),
});

export type ServerIdentity = z.infer<typeof ServerIdentitySchema>;
export type AgentStatus = z.infer<typeof AgentStatusSchema>;
export type Heartbeat = z.infer<typeof HeartbeatSchema>;
export type ServerProfile = z.infer<typeof ServerProfileSchema>;
export type ServerCommand = z.infer<typeof ServerCommandSchema>;
export type CommandAcknowledgement = z.infer<
  typeof CommandAcknowledgementSchema
>;
export type ServerEvent = z.infer<typeof ServerEventSchema>;
export type Match = z.infer<typeof MatchSchema>;

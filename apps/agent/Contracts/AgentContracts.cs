namespace NortePlay.Agent.Contracts;

public sealed record ServerIdentity(Guid ServerId, Guid AgentId);
public enum AgentStatus { Provisioning, Online, Offline, Degraded, Revoked }
public sealed record Heartbeat(ServerIdentity Identity, long Sequence, DateTimeOffset SentAt, AgentStatus Status);
public enum ServerCommandType { Start, Stop, ApplyProfile, CollectStatus }
public sealed record ServerCommand(Guid CommandId, Guid ServerId, long Sequence, string IdempotencyKey, ServerCommandType Type, DateTimeOffset IssuedAt, DateTimeOffset ExpiresAt);
public enum CommandStatus { Accepted, Running, Succeeded, Failed, Rejected }
public sealed record CommandAcknowledgement(Guid CommandId, Guid ServerId, long Sequence, CommandStatus Status, DateTimeOffset OccurredAt, string? Detail);
public sealed record ServerEvent(Guid EventId, Guid ServerId, Guid AgentId, long Sequence, string Type, DateTimeOffset OccurredAt);
public enum ServerProfile { Mix, Competitive }

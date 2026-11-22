using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

internal sealed class AgentWorker(ILogger<AgentWorker> logger) : BackgroundService
{
    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        logger.LogInformation("NORTE PLAY agent scaffold started; transport and server operations are not configured.");
        return Task.CompletedTask;
    }
}

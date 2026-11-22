using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddWindowsService(options => options.ServiceName = "NORTE PLAY CS2 Agent");
builder.Services.AddHostedService<AgentWorker>();
await builder.Build().RunAsync();

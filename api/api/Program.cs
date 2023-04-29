using Api.Options;
using Api.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddFastEndpoints();
builder.Services.Configure<HashSettings>(builder.Configuration.GetSection(HashSettings.Position));
builder.Services.AddSingleton<IHashService, HashService>();
var app = builder.Build();

app.UseFastEndpoints();
app.Run();

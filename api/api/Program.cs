using Api.Models;
using Api.Options;
using Api.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddFastEndpoints();
builder.Services.Configure<HashSettings>(builder.Configuration.GetSection(HashSettings.Position));
builder.Services.AddSingleton<IHashService, HashService>();
builder.Services.AddDbContext<ApplicationContext>(options =>
{
    options.UseSqlite(builder.Configuration.GetConnectionString("ApplicationContext"));

    if (builder.Environment.IsDevelopment())
    {
        options.EnableSensitiveDataLogging();
    }
});

var app = builder.Build();

await using (var scope = app.Services.CreateAsyncScope())
{
    var applicationContext = scope.ServiceProvider.GetService<ApplicationContext>()!;
    await applicationContext.Database.MigrateAsync();
}

app.UseFastEndpoints();
app.Run();

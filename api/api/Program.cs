using Api.Auth;
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
builder.Services.AddAuthentication("Basic")
    .AddScheme<BasicAuthenticationSchemeOptions, BasicAuthenticationSchemeHandler>(
        "Basic", options => { });

var app = builder.Build();

await using (var scope = app.Services.CreateAsyncScope())
{
    var applicationContext = scope.ServiceProvider.GetService<ApplicationContext>()!;
    await applicationContext.Database.MigrateAsync();
}
app.UseAuthentication();
app.UseAuthorization();
app.UseFastEndpoints(c =>
{
    c.Serializer.Options.PropertyNamingPolicy = null;
});
app.Run();

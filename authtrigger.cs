using System.Net.Http.Json;
using Functions.Models;
using Functions.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Company.Function;

public class Authtrigger
{
    private readonly ILogger<Authtrigger> _logger;

    public Authtrigger(ILogger<Authtrigger> logger)
    {
        _logger = logger;
    }

    [Function("authtrigger")]
    public async Task<IActionResult> Run(
        [HttpTrigger(AuthorizationLevel.Function, "get", "post")]
        HttpRequest req, ILogger log)
    {
        string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var user = System.Text.Json.JsonSerializer.Deserialize<User>(requestBody);
        if (user == null || string.IsNullOrEmpty(user.Username))
        {
            _logger.LogError("Invalid user data provided.");
            return new BadRequestObjectResult("Invalid user data.");
        }
        _logger.LogInformation("C# HTTP trigger function processed a request.");
        var token = TokenService.GenerateToken(user);
        return new OkObjectResult(new { token });
    }
}
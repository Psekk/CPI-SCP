using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using V2.Data;
using V2.Models;
using Xunit;

namespace ParkingApi.Tests.Integration;

/// <summary>
/// Integration tests for Discount endpoints using real Turso database.
/// </summary>
public class DiscountIntegrationTests : IntegrationTestBase
{
    public DiscountIntegrationTests(CustomWebApplicationFactory factory) : base(factory)
    {
    }

    #region POST /discounts - Create Discount

    [Fact]
    public async Task CreateDiscount_ReturnsCreated_WhenValidPercentageDiscount()
    {
        var token = await CreateAdminAndGetTokenAsync();
        var authClient = CreateAuthenticatedClient(token);

        var discountRequest = new
        {
            Code = $"SUMMER{Guid.NewGuid().ToString("N")[..4]}",
            Description = "Summer Sale",
            Type = DiscountType.Percentage,
            Percentage = 10,
            ValidUntil = DateTime.UtcNow.AddDays(7)
        };

        var response = await authClient.PostAsJsonAsync("/admin/discounts", discountRequest);
        Assert.True(response.IsSuccessStatusCode, $"Expected success but got {response.StatusCode}");
    }

    #endregion
}

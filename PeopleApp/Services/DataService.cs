using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using TestSolution.Models;

namespace PeopleApp.Services;

public class DataService
{
    private IConfiguration Configuration { get; }
    private static string? ConnectionString { get; set; }

    public DataService(IConfiguration configuration)
    {
        Configuration = configuration;
        ConnectionString = Configuration.GetConnectionString("Dev");
    }

    public async Task<IEnumerable<Person>> GetPeople()
    {
        IEnumerable<Person> people;

        await using var conn = new SqlConnection(ConnectionString);
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        try
        {
            people = await conn.QueryAsync<Person>("dbo.GetPeople", commandType: CommandType.StoredProcedure);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
                conn.Close();
        }

        return people;
    }
}
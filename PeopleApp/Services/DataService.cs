using System.Data;
using Dapper;
using TestSolution.Models;
using TestSolution.Shared;

namespace PeopleApp.Services;

public class DataService(IConfiguration configuration)
{
    private readonly DataHelper _dataHelper = new(configuration);

    public async Task<List<Person>> GetPeople()
    {
        await using var conn = _dataHelper.GetConnection();
        var people = await conn.QueryAsync<Person>("dbo.GetPeople", commandType: CommandType.StoredProcedure);
        conn.Close();
        return people.ToList();
    }

    public async Task<int> AddPerson(Person newPerson)
    {
        var dt = _dataHelper.ConvertObjectToDataTable(newPerson);
        await using var conn = _dataHelper.GetConnection();
        var personId = await conn.ExecuteScalarAsync<int?>
        ("dbo.AddPerson",
            new { Person = dt.AsTableValuedParameter("UT_People") },
            commandType: CommandType.StoredProcedure) ?? 0;

        return personId;
    }
}
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
        return people.ToList();
    }

    public async Task<string?> AddPerson(Person newPerson)
    {
        var dt = _dataHelper.ConvertObjectToDataTable(newPerson);
        var p = new DynamicParameters();
        p.Add("Person", dt.AsTableValuedParameter("UT_People"));
        p.Add("Message", dbType: DbType.String, direction: ParameterDirection.Output);
        await using var conn = _dataHelper.GetConnection();
        var message = await conn.ExecuteScalarAsync<string?>
            ("dbo.AddPerson", p, commandType: CommandType.StoredProcedure);

        return message;
    }

    public async Task<string?> UpdatePerson(Person changedPerson)
    {
        var dt = _dataHelper.ConvertObjectToDataTable(changedPerson);
        var p = new DynamicParameters();
        p.Add("Person", dt.AsTableValuedParameter("UT_People"));
        p.Add("Message", dbType: DbType.String, direction: ParameterDirection.Output);
        await using var conn = _dataHelper.GetConnection();
        var message = await conn.ExecuteScalarAsync<string?>
            ("dbo.UpdatePerson", p, commandType: CommandType.StoredProcedure);

        return message;
    }

    public async Task<string?> DeletePerson(int personId)
    {
        await using var conn = _dataHelper.GetConnection();
        var message = await conn.ExecuteScalarAsync<string>
        ("dbo.DeletePerson", personId,
            commandType: CommandType.StoredProcedure);

        return message;
    }
}
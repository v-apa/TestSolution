using Microsoft.AspNetCore.Components;
using PeopleApp.Services;
using TestSolution.Models;

namespace PeopleApp.Components.Pages;

public abstract class PeopleBase : ComponentBase
{
    [Inject] protected DataService Data { get; set; } = default!;

    protected Person[]? People;

    protected override async Task<Person[]> OnInitializedAsync()
    {
        IEnumerable<Person> peopleList = await Data.GetPeople();

        People = peopleList.ToArray();

        return People;
    }
}

/*using BlazorTest.Models;
using BlazorTest.Services;
using Microsoft.AspNetCore.Components;

namespace BlazorTest.Components.Pages;

public class PromotionGridBase : ComponentBase
{
    [Inject]
    protected DataService Data { get; set; } = default!;

    protected Person[]? People;
    protected override async Task<Person[]> OnInitializedAsync()
    {

        IEnumerable<Person> peopleList = await Data.GetPeople();

        People = peopleList.ToArray();

        return People;
    }*/
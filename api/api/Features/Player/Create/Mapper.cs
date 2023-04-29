namespace Api.Features.Player.Create;

public class Mapper : Mapper<Request, Response, Models.Player>
{
    private readonly IHashService _hashService;

    public Mapper(IHashService hashService)
    {
        _hashService = hashService;
    }

    public override Models.Player ToEntity(Request r) => new()
    {
        UserName = r.UserName
    };

    public override Response FromEntity(Models.Player e) => new()
    {
        Key = _hashService.EncodePlayerID(e.PlayerID)
    };
}

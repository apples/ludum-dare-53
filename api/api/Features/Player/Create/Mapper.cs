namespace Api.Features.Player.Create;

public class Mapper : Mapper<Request, Response, Entities.Player>
{
    private readonly IHashService _hashService;

    public Mapper(IHashService hashService)
    {
        _hashService = hashService;
    }

    public override Entities.Player ToEntity(Request r) => new()
    {
        UserName = r.UserName
    };

    public override Response FromEntity(Entities.Player e) => new()
    {
        Key = _hashService.EncodePlayerID(e.PlayerID)
    };
}

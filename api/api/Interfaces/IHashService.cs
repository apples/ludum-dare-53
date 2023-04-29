using Api.Entities;

namespace Api.Interfaces;

public interface IHashService
{
    public string EncodePlayerID(PlayerID playerID);

    public PlayerID? DecodePlayerID(string playerHash);
}

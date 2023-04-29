using HashidsNet;

using Microsoft.Extensions.Options;
using Api.Options;
using Api.Entities;

namespace Api.Services;

public class HashService : IHashService
{
    private readonly Hashids _playerHashids;

    public HashService(IOptions<HashSettings> hashSettingsOptions)
    {
        var hashSettings = hashSettingsOptions.Value;

        _playerHashids = new Hashids(hashSettings.PlayerSalt, hashSettings.PlayerMinLength);
    }

    public string EncodePlayerID(PlayerID playerID) =>
        _playerHashids.Encode(playerID.Value);

    public PlayerID? DecodePlayerID(string playerHash) =>
        _playerHashids.TryDecodeSingle(playerHash, out var id) ? new PlayerID(id) : null;
}

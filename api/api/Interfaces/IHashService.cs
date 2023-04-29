namespace Api.Interfaces;

public interface IHashService
{
    public string EncodePlayerID(int playerID);

    public int? DecodePlayerID(string playerHash);
}

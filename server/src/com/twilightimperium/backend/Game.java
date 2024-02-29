package com.twilightimperium.backend;

import java.util.*;

import com.twilightimperium.backend.model.game.BoardState;
import com.twilightimperium.backend.model.game.GameState;
import com.twilightimperium.backend.model.game.Location;
import com.twilightimperium.backend.model.game.Ship;
import com.twilightimperium.backend.model.game.Tile;


public class Game {
    private static final int ACTION = 0;
    private static final int MOVE = 1;
    private GameState state;
    private Map<String,Integer> tokens;
    int playerNum; //stores the next player # to hand out. The first player is 0, the second is 1 etc.
    Location activeSystem;
    int activePlayer;
    int maxPlayers;
    int nextCommand; //This stores what the game is waiting on. Does it expect an activate system or move command etc.

    public String jsonGameState(){
        //encode state as json
        return null;
    }
    
    public GameState getGameState(){
        return state;
    }

    public Game(){
        nextCommand = 0; // we start for now by expecting an activate System command
        playerNum = 0;
        tokens = new HashMap<String, Integer>();
        state = new GameState(maxPlayers);
        activePlayer = 0; //assume that the creator of the game goes first;
        maxPlayers = 6;
        activeSystem = new Location(-1,-1);
    }


    public void addPlayer(String token) {
        if(playerNum < maxPlayers){
            tokens.put(token, playerNum);
            playerNum++;
        } else {
            throw new RuntimeException();
        }
    }

    public boolean activateSystem(int x, int y, String token){
        //first we get the player number from the token.
        if(nextCommand == ACTION){
            int player = tokens.get(token);
            boolean success = placeTokenSystem(x, y, player);
            if (success){
                nextCommand = MOVE;
            }
            return success;
        } else {
            return false;
        }
    }

    private boolean placeTokenSystem(int x, int y, int player){
            activeSystem.x = x;
            activeSystem.y = y;

            //true indicates a success
            //false indicates that the tile was already activated by that player
            return state.getMap().activateTile(x, y, player);
    }

    public boolean move(Ship[] ships){
        if(nextCommand == MOVE){
            boolean success = moveShips(new ArrayList<Ship>(Arrays.asList(ships)));
            if (success){
                nextCommand = ACTION;
            }
            return success;
        }else {
            return false;
        }
    }

    private boolean moveShips(List<Ship> ships){
        //The clone function currently DOES NOT work. It's fine though, because validateMove doesn't work either
        BoardState oldMap = state.getMap().clone();
        for(Ship currentShip : ships){
            if(!validateMove(currentShip, activeSystem)){
                state.setMap(oldMap);
                return false;
            } else {
                state.getMap().addShip(activeSystem.x, activeSystem.y, currentShip.getShipClass());
                state.getMap().removeShip(currentShip.getX(), currentShip.getY(), currentShip.getShipClass());
            }
        }
        return true;

    }

    public boolean validateMove(Ship ship, Location end) {
        return true;
        /*BoardState board = state.getMap();
        int[7][7] visited = {false};
        if()
        */
    }

    private boolean validateMoveHelper(Location current, Location goal, int remaining, int[][] visited, BoardState board){
        //TODO INCOMPLETE
        if (current.x > 6 || current.x < 0 || current.y > 6 || current.y < 0){
            return false;
        }
        if (remaining < 0){
            return false;
        }
        if(current.x == goal.x && current.y == goal.y){
            return true;
        }
        if(remaining == 0){
            return false;
        }
        if (visited[current.y][current.x] >= remaining){
            return false;
        }
        String anomaly = board.getTile(current.x,current.y).getAnomaly();
        if(anomaly == null || anomaly.equals("planet")){
            Location newCoords = new Location(current.x+1,current.y-1);
            if(validateMoveHelper(newCoords, goal, remaining-1, visited, board)){
                return true;
            }
            newCoords = new Location(current.x+1,current.y);
            if(validateMoveHelper(newCoords, goal, remaining-1, visited, board)){
                return true;
            }
            newCoords = new Location(current.x,current.y+1);
            if(validateMoveHelper(newCoords, goal, remaining-1, visited, board)){
                return true;
            }
            newCoords = new Location(current.x-1,current.y);
            if(validateMoveHelper(newCoords, goal, remaining-1, visited, board)){
                return true;
            }
            newCoords = new Location(current.x,current.y-1);
            if(validateMoveHelper(newCoords, goal, remaining-1, visited, board)){
                return true;
            }
            newCoords = new Location(current.x-1,current.y+1);
            if(validateMoveHelper(newCoords, goal, remaining-1, visited, board)){
                return true;
            }
            visited[current.y][current.x] = remaining;
            return false;
        }
        return false;
    }


    // Other methods
}


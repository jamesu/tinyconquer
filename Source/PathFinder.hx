package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;

class PathFinder {
	
	public var field : PlayField;

	public var grid: Array<PathNode>;

	public var openList : Array<PathNode>;
	public var closedList : Array<PathNode>;

	public function new (playField : PlayField) {
		field = playField;
	}

	public function reset()
	{
		var node;
		for (node in grid) {
			node.g = 0;
			node.h = 0;
			node.f = 0;
			node.parent = null;
			node.scanFlags = 0;
		}

		openList = new Array<PathNode>();
		closedList = new Array<PathNode>();
	}

	public function nodeAtTile(x : Int, y : Int) : PathNode {
		if (x < 0 || y < 0 || x >= field.tileWidth || y >= field.tileHeight)
			return null;
		else
			return grid[(y * field.tileWidth) + x];
	}

	public function distScoreBetween(node : PathNode, node2 : PathNode) {
		// Diagonals
		if (node2.x != node.x && node2.y != node.y)
			return 14;
		else
			return 10;
	}

	public function heuristicCostEstimate(node : PathNode, dest : PathNode) {
		var deltaX = (dest.x - node.x);
		if (deltaX < 0) deltaX = -deltaX;
		var deltaY = (dest.y - node.y);
		if (deltaY < 0) deltaY = -deltaY;
		return (deltaX + deltaY) * 10;
	}

	public function addAndScoreNode(node : PathNode, score : Int, parent : PathNode, dest : PathNode) {
		if (node.scanFlags == PathNode.SCAN_CLOSED)
			return;

		var tentative_is_better = false;
		var distScore = distScoreBetween(parent, node);
		var tenative_g_score = parent.g + distScore;

		// ignore node if we are going around a corner
		if (distScore == 14) {
			var node1 = nodeAtTile(node.x, parent.y);
			var node2 = nodeAtTile(parent.x, node.y);

			if ((node1.flags & PathNode.BLOCK != 0) || (node2.flags & PathNode.BLOCK != 0))
				return;
		}

		if (node.scanFlags != PathNode.SCAN_OPEN) {
			node.scanFlags = PathNode.SCAN_OPEN;
			openList.push(node);
			node.h = heuristicCostEstimate(node, dest);
			tentative_is_better = true;
		} else if (tenative_g_score < node.g) {
			tentative_is_better = true;
		} else {
			tentative_is_better = false;
		}

		if (tentative_is_better) {
			node.parent = parent;
			node.g = tenative_g_score;
			node.f = node.g + node.h;
		}
	}

	public function getLowestOpenNode() : PathNode
	{
		var best : PathNode = null;
		var lowest = 0xFFFFFF;
		var open;
		for (open in openList) {
			if (open.f < lowest) {
				best = open;
				lowest = open.f;
			}
		}
		return best;
	}

	public function addToOpen(node : PathNode)
	{
		openList.push(node);
		node.scanFlags = PathNode.SCAN_OPEN;
	}

	public function addToClosed(node : PathNode)
	{
		openList.remove(node);
		closedList.push(node);
		node.scanFlags = PathNode.SCAN_CLOSED;
	}

	public function findPathFromTo(x : Int, y : Int, dx : Int, dy : Int) : Array<PathNode> {
		reset();

		var tileX = Math.floor(x / 32);
		var tileY = Math.floor(y / 32);
		var destTileX = Math.floor(dx / 32);
		var destTileY = Math.floor(dy / 32);

		var mapWidth = field.tileWidth;
		var mapHeight = field.tileHeight;

		var startNode = nodeAtTile(tileX, tileY);
		var endNode = nodeAtTile(destTileX, destTileY);
		var currentNode = startNode;

		if (startNode == null || endNode == null) {
			return null;
		}

		if (startNode == endNode)
			return [startNode];

		openList.push(startNode);
		startNode.g = 0;
		startNode.h = heuristicCostEstimate(startNode, endNode);
		startNode.f = startNode.h;

		while (openList.length != 0 && currentNode != endNode) {
			addToClosed(currentNode);

			//trace("itr ++", openList);
			
			// Adjacent squares
			var node;
			node = nodeAtTile(currentNode.x-1, currentNode.y-1);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 14, currentNode, endNode); }
			node = nodeAtTile(currentNode.x, currentNode.y-1);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 10, currentNode, endNode); }
			node = nodeAtTile(currentNode.x+1, currentNode.y-1);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 14, currentNode, endNode); }
			node = nodeAtTile(currentNode.x-1, currentNode.y);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 10, currentNode, endNode); }
			node = nodeAtTile(currentNode.x+1, currentNode.y);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 10, currentNode, endNode); }
			node = nodeAtTile(currentNode.x-1, currentNode.y+1);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 14, currentNode, endNode); }
			node = nodeAtTile(currentNode.x, currentNode.y+1);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 10, currentNode, endNode); }
			node = nodeAtTile(currentNode.x+1, currentNode.y+1);
			if (node != null && node.flags == 0) { addAndScoreNode(node, 14, currentNode, endNode); }

			// Pick lowest scored node
			currentNode = getLowestOpenNode();
		}

		// Found best path? Enumerate it
		if (currentNode == endNode) {
			var outPath = new Array<PathNode>();
			while (currentNode != startNode) {
				outPath.push(currentNode);
				currentNode = currentNode.parent;
			}
			outPath.reverse();
			return outPath;
		}

		return null;
	}

	public function generateGrid() {
		// Generate a walkable-nonwalkable from the playfield
		grid = new Array<PathNode>();

		var i : Int;
		for (i in 0...field.tiles.length) {
			var node = new PathNode();
			node.x = i % field.tileWidth;
			node.y = Math.floor(i / field.tileWidth);
			grid.push(node);
		}

		var tileIDX;
		var x=0;
		var y=0;
		var count = 0;
		for (tileIDX in field.tiles) {
			// 
			var tile = field.tileData[tileIDX];
			if ((tile.flags & TileData.COLLISION_BLOCK) != 0) {
				grid[count].flags = TileData.COLLISION_BLOCK;
			} else {
				grid[count].flags = 0;
			}

			x += 1;
			if (x == field.tileWidth) {
				x = 0;
				y += 1;
			}
			count += 1;
		}

		reset();
	}
}